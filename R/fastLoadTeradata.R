#' Fast load Teradata
#'
#' Esta función permite un Fast Load a teradata 
#' Es necesario establecer previamente una variable con la conexion a teradata
#'
#' @param NombreTabla Es el nombre de la tabla que va a quedar en teradata
#' @param NumeroCampos es el numero de campos (?) que definen la tabla 
#' @param EstructuraTabla Estructura de la tabla, nombre de columnas y tipos
#' @param DatosDF datos que contendra la tabla, previamente definidos
#' @param ConexionTera Variable que contiene el formato de conexion a teradata
#' @return El numero de registros almacenados
#' @keywords fastLoadTeradata datos teradata
#' @export
#' @example
#' fastLoadTeradata("Base_Datos.Nombre_tabla", 84, createTable, df, con)
fastLoadTeradata <- function(table_name, n_campos, createTable, df, con){
    
    dropQry <- paste("DROP TABLE", table_name)
    
    #Generacion de (?) para campos definición de campos vacios
    caracter <- '?,'
    string <- paste(replicate(n_campos, caracter), collapse = "")
    n <- base::substr(string,1 , n_campos*2 - 1)
    generate <- paste0("(",n, ")")
    
    sInsert <- paste("{fn teradata_try_fastload}INSERT INTO", table_name, generate)
    
    tryCatch ({
        cat("Se hizo \n")
        sRequest <- paste0 ("DROP TABLE ", table_name)
        cat(paste0 (sRequest, "\n"))
        
        DBI::dbExecute (con, sRequest)
    }, error = function (e) {
        cat(paste0 ("Ignoring this ", strsplit (trimws (e), "\n") [[1]][[1]], "\n"))
        cat("La tabla no existia, no hizo drop pero no hay problema \n")
     
    })

    DBI::dbExecute(con, createTable)
    cat(paste("Luego \nCREATE TABLE", table_name,"\n"))
    DBI::dbExecute(con, sInsert, df)
    cat(paste("Y se inserto la data"))
    
}
