#' Query a teradata
#'
#' Esta función permite hacer consultas tipo SQL a teradata mediante un query, 
#' pasando como parametros el user y la contraseña
#' establecidos para teradata
#'
#' @param myQuery Es el Query con el cual se hara la consulta a teradata
#' @param user es el nombre de user de la compañia asignado para acceder a teradata
#' @param password es el password establecido para accedera a teradata
#' @param host direccion ip de host de teradata
#' @return Un dataframe con los datos resultantes de la consulta, si entra un arreglo retorna un arreglo con los resultados
#' @keywords extraer datos teradata
#' @export
#' @example
#' queryTeradata("SELECT * FROM XXXX",  "user", "password")
#'


queryTeradata <- 
    function (myQuery,
           user = NULL,
           password = NULL,
           host = "10.205.24.12"){
        con <- DBI::dbConnect(teradatasql::TeradataDriver(), host = "10.205.24.12", user = user, password = password)
        DBI::dbGetQuery(con, myQuery)
  }