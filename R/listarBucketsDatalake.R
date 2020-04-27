#' Listar nombres de buckets en el datalake
#'
#' Esta función lista los buckets del datalake existentes en AWS S3. Devuelve una lista con los nombres.
#' Se requiere un access_key_id y un aws_secret_key_id que son generados
#' cuando se solicita el acceso al datalake, para ser establecidos a traves de aws CLI en el computador.
#' 
#' @return lista con todos los nombre de los buckets existentes en el datalake
#' @keywords listar buckets s3
#' @export
#' @examples
#' listarBucketsDatalake()

# """
listarBucketsDatalake <- function(){
    extraccion_buckets_s3 <- function(){
    require(data.table)
    require(reticulate)
    require(aws.s3)
    boto3 <- reticulate::import("boto3")
    client_s3 <- boto3$client("s3")
    resource_s3 <- boto3$resource("s3")
    response = client_s3$list_buckets()
    return (response['Buckets'][[1]]) 
}

clean <- extraccion_buckets_s3()

cat(do.call(what = paste, args = c(lapply(X = clean, FUN = function(x){return (x[["Name"]])}), sep="\n")))    
    
    
    
}
