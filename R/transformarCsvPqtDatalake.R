#' Transforma un archivo csv a parquet en el  datalake
#'
#' Esta función permite transformar un archivo en formato .csv a formato .pqt usando 
#' la herramient glue del datalake. Ademas hace el movimiento entre las zonas del 
#' datalake si es necesario
#'
#' @param archivo_fuente Es el dataframe que sufrira la transformación
#' @param archivo_destino es el nombre con el que quedara el archivo luego de transformarlo 
#' @param zona_dl_fuente zona del datalake donde se encuentra el archivo que sera transformado
#' @param zona_dl_destino zona del datalake donde se almacenara el archivo transformado
#' @param ruta_proyecto_dl ruta de directorio dentro de un bucket del datalake
#' @return La ruta en S3 del archivo resultante
#' @keywords extraer datos datalake
#' @export
#'
transformarCsvPqtDatalake <-
  function(archivo_fuente,
           archivo_destino,
           zona_dl_fuente="",
           zona_dl_destino="",
           ruta_proyecto_dl="",
           rol_aws='AWSGlueServiceRoleDefaultSura',
           aws_access_key_id = NULL,
           aws_secret_access_key = NULL
  ){
    require(reticulate)
    boto3 <- import("boto3")
    client = boto3$client('glue')

    script_s3_path='s3://script-glue-analitica/martin.arrieta/csv_to_pqt_no_catalog.py'

    dl_fuente_paths <- analiticasura.util.s3_paths_dl(archivo_fuente, ruta_proyecto_dl,zona_dl_fuente)
    s3_path_fuente<- dl_fuente_paths$s3_path
    archivo_fuente <- dl_fuente_paths$nombre_archivo
    archivo_fuente_sin_ext <- dl_fuente_paths$nombre_archivo_sans_ext

    dl_destino_paths <- analiticasura.util.s3_paths_dl(archivo_destino, ruta_proyecto_dl,zona_dl_destino)
    s3_path_destino <- dl_destino_paths$s3_path

    nombre_job <- paste0(archivo_fuente_sin_ext, "_pqt")

    client$create_job(
      Name=nombre_job,
      Role=rol_aws,
      Command=list(
        Name= 'glueetl',
        ScriptLocation=script_s3_path
      ),
      MaxCapacity=2
    )

    job_start_resp <- client$start_job_run(
      JobName=nombre_job,
      Arguments=list(
        '--origin_path' = s3_path_fuente,
        '--dest_path' = s3_path_destino
      ),
      MaxCapacity=2
    )

    job_run_id <- job_start_resp$JobRunId

    status <- list(JobRunState="STARTING")

    while(status$JobRunState %in% c('STARTING','RUNNING', 'STOPPING')){
      Sys.sleep(2)
      status <- client$get_job_run(
        JobName=nombre_job,
        RunId=job_run_id
      )$JobRun
    }

    if(status$JobRunState != 'SUCCEEDED')
      stop(paste("JOBRUN: La transformación falló cuando se intentaba realizar sobre: ",s3_path_fuente,
                 "hacia: ",s3_path_destino, "el estado es:", status$JobRunState,
                 "el mensaje de error es:",status$ErrorMessage ))
  }
