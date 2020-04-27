#' Query a teradata de manera segura
#'
#' Esta función permite hacer consulta SQL a teradata mediante un query, usando el password ecriptado en 
#' dos archivos de llaves generados previamente mediante TJEncryptPassword.R
#' las llaves que contienen la clave encriptada deben estar en el mismo directorio que el notebook a ejecutar
#'
#' @param myQuery Es el Query con el cual se hara la consulta a teradata
#' @param user es el nombre de user de la compañia asignado para acceder a teradata
#' @param password es el password establecido para accedera a teradata
#' @param host direccion ip de host de teradata
#' @return Un dataframe con los datos resultantes de la consulta, si entra un arreglo retorna un arreglo con los resultados
#' @keywords extraer datos teradata
#' @export
#' @example
#' queryTeradataSeguro("SELECT * FROM XXXX",  "user")
#'

queryTeradataSeguro <-
  function(myQuery,
           user = NULL,
           password = NULL,
           host = "10.205.24.12"){
      PASS_PATH <- Sys.getenv("PWD")
      #PASS_PATH <- paste0(PASS_PATH, "/notebooks")
      sPassword <- paste0 ("ENCRYPTED_PASSWORD(file:", PASS_PATH,"/PassKey.properties", ",file:",PASS_PATH,"/EncPass.properties", ")")
      con <- DBI::dbConnect(teradatasql::TeradataDriver(), host = "10.205.24.12", user = user, password = sPassword)
      DBI::dbGetQuery(con, myQuery)
  }