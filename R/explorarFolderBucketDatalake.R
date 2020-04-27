#' Explora una carpeta dentro de un bucket del Datalake
#'
#' Esta funcion permite explorar el contenido existente de una carpeta ubicada de un bucket en el datalake
#' Solo devuelve el contenido si el usuario tiene permisos de lectura sobre el bucket consultado
#'
#' @param bucket_name nombre del bucket que se quiere consultar
#' @param folder nombre de la carpeta a consultar dentro del bucket
#' @return lista con los objetos existentes dentro de la carpeta en el bucket consultado
#' @keywords explorar folder carpeta bucket s3 datalake
#' @export
#' @examples
#' explorarFolderBucketDatalake('landing-zone-analitica','Capacitacion')
#'

explorarFolderBucketDatalake <- function(bucket_name, folder){
    require(reticulate)
    require(aws.s3)
    boto3 <- reticulate::import("boto3")
    client <- boto3$client("s3")
    objeto <- client$list_objects(Bucket = bucket_name, Prefix = folder)['Contents'][[1]]
    do.call("cat", c(lapply(X = objeto, FUN = function(x){x[['Key']]}), sep="\n"))

}