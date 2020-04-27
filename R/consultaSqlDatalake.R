#' Consulta SQL a Athena
#'
#' Esta función realiza una consutla SQL al datalake por medio de AWS athena, devuelve en dataframe una tabla.
#' se requiere un access_key_id y un aws_secret_key_id que son generados
#' cuando se solicita el acceso al datalake, para ser establecidos a traves de aws CLI en el computador. 
#
#' @param query Es el codigo de la consulta en SQl, ej: 'SELECT * FROM "database"."tablename"'
#' @param path Es la ruta del folder del proyecto dentro de un bucket en s3, ej 's3://landing-zone-analitica/movilidad_segura'
#' @return 
#' @keywords consulta sql athena
#' @export
#' @examples
#' consultaSqlDatalake('SELECT * FROM "databasetest"."tabletest"',"s3://landing-zone-analitica/movilidad_segura")    
#'
#'

consultaSqlDatalake <- function(workgroup, query, path, soloEjecutar = FALSE){
    
    require("data.table")
    require(reticulate)
    require(aws.s3)
    
    boto3 <- reticulate::import("boto3")
    client <- boto3$client("athena")

    res <- lapply(query, function(q) {
        query_id <- client$start_query_execution(
            
            QueryString=q,
            ResultConfiguration=list(OutputLocation = path),WorkGroup= "Group-Analitica"
            )$QueryExecutionId
    })

    if(!soloEjecutar){
        res <- lapply(res, function(query_id){
            query_status = "QUEUED"
            while(query_status %in% c("QUEUED", "RUNNING")  ){
                Sys.sleep(2)
                query_status <- client$get_query_execution(QueryExecutionId=query_id)$QueryExecution$Status$State
            }
            if(query_status %in% c('FAILED', 'CANCELLED')){
                stop(query_status)
            }

            csv_path <- client$get_query_execution(QueryExecutionId=query_id)$QueryExecution$ResultConfiguration$OutputLocation
            df <- s3read_using(read.csv, object = csv_path)
            dataframe <- as.data.frame(df)
            print(df)
            df
            #print(dataframe)
            return(dataframe)
        })
    }

  }
