#' Descargar datos del Datalake
#'
#' Esta funcion permite descargar un archivo de datos en el Datalake en AWS por medio de s3,
#' para descargar la información se requiere un access_key_id y un aws_secret_key_id que son generados
#' cuando se solicita el acceso al datalake a AWS S3, para ser establecidos a traves de 
#' aws CLI en el computador. 
#'
#' @param bucket_name Es el nombre del bucket en s3 de la zona del datalake donde se almacenarán los datos, ej: 'landing-zone-analitica'
#' @param folder Es el nombre de la carpeta dentro del bucket en s3, normalmente corresponde al nombre del proyecto, ej: 'movilidad_segura'
#' @param s3_file_name Es el nombre que tendra el archivo de datos dentro del datalake, ej: 'estados_clientes_mv.csv'
#' @param output_name Es la localización local donde se va a descargar el archivo o dataframe, o nombre con el que se guardará, ej: 'estados_clientes.csv'
#' @return Un dataframe con los datos resultantes de la consulta, si entra un arreglo retorna un arreglo con los resultados.
#' @keywords descargar datos s3
#' @export
#' @examples
#' descargarDatosDatalake('landing-zone-analitica', 'movilidad_segura', 'estados_clientes_mv.csv', 'estados_clientes.csv')
#'

descargarDatosDatalake <- function(bucket_name, folder, s3_file_name, output_name){
    require(data.table)
    require(reticulate)
    require(aws.s3)
    boto3 <- reticulate::import("boto3")
    client_s3 <- boto3$client("s3")
    resource_s3 <- boto3$resource("s3")
    path <- paste(folder, s3_file_name, sep="/")
    resource_s3$meta$client$download_file(bucket_name, path, output_name) 
}