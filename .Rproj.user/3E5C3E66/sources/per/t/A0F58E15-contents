#' Cargar datos en el Datalake en AWS
#'
#' Esta función permite cargar datos en el Datalake en AWS por medio de s3,
#' para cargar la información se requiere un access_key_id y un aws_secret_key_id
#' que es generado cuando se solicita el acceso al datalake de la compañia.
#'
#' @param local_file Es el archivo local o dataframe que se almacenará en AWS, ej: 'estados_clientes.csv'
#' @param bucket_name Es el nombre del bucket en s3 de la zona del datalake donde se almacenarán los datos, ej: 'landing-zone-analitica'
#' @param folder Es el nombre de la carpeta dentro del bucket en s3, normalmente corresponde al nombre del proyecto, ej: 'movilidad_segura'
#' @param s3_file_name Es el nombre que tendra el archivo de datos dentro del datalake
#' @return Un dataframe con los datos resultantes de la consulta, si entra un arreglo retorna un arreglo con los resultados.
#' @keywords cargar datos datalake
#' @export
#' @examples
#' cargarDatosDatalake('estados_clientes.csv','landing-zone-analitica','movilidad_segura','estados_clientes_ms.csv')
#'

cargarDatosDatalake <- function(local_file, bucket_name, folder, s3_file_name){
    require(data.table)
    require(reticulate)
    require(aws.s3)
    boto3 <- reticulate::import("boto3")
    client_s3 <- boto3$client("s3")
    resource_s3 <- boto3$resource("s3")
    path <- paste(folder, s3_file_name, sep="/")
    resource_s3$meta$client$upload_file(local_file, bucket_name, path) 
}