% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fastLoadTeradata.R
\name{fastLoadTeradata}
\alias{fastLoadTeradata}
\title{Fast load Teradata}
\usage{
fastLoadTeradata(name_table, n_campos, createTable, df, con)
}
\arguments{
\item{NombreTabla}{Es el nombre de la tabla que va a quedar en teradata}

\item{NumeroCampos}{es el numero de campos (?) que definen la tabla}

\item{EstructuraTabla}{Estructura de la tabla, nombre de columnas y tipos}

\item{DatosDF}{datos que contendra la tabla, previamente definidos}

\item{ConexionTera}{Variable que contiene el formato de conexion a teradata}
}
\value{
El numero de registros almacenados
}
\description{
Esta función permite un Fast Load a teradata 
Es necesario establecer previamente una variable con la conexion a teradata
}
\keyword{datos}
\keyword{fastLoadTeradata}
\keyword{teradata}
