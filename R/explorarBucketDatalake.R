#' Explora dentro de un bucket del Datalake
#'
#' Esta funcion permite explorar el contenido existente dentro de un bucket en el datalake
#' Solo devuelve el contenido si el usuario tiene permisos de lectura sobre el bucket consultado
#'
#' @param bucket_name nombre del bucket que se quiere consultar
#' @return lista con los objetos existentes dentro del bucket consultado
#' @keywords explorar bucket s3 datalake
#' @export
#' @examples
#' explorarBucketDatalake('landing-zone-analitica')
#'



explorarBucketDatalake <- function(bucket_name){
    require(reticulate)
    require(aws.s3)
    boto3 <- reticulate::import("boto3")
    client_s3 <- boto3$client("s3")
    prefix <- client_s3$list_objects_v2(Bucket=bucket_name, Delimiter='/')['CommonPrefixes']
    #lapply(X = prefix[[1]], FUN = function(x){x[[1]]})
    do.call("cat", c(lapply(X = prefix[[1]], FUN = function(x){x[[1]]}), sep='\n'))
    }