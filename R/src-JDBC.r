#' @import dplyr
NULL

#' Connect to Netezza database with a Netezza JDBC driver
#' 
#' Use \code{src_JDBC} to connect to Netezza database with JDBC driver.
#' @export
src_JDBC <- function(driver, dbname = NULL, host = NULL, port = NULL, user = NULL, password = NULL, url = NULL, ...) {
  if (!require("RJDBC")) {
    stop("RJDBC package required to connect to JDBC db", call. = FALSE)
  }

  user <- user %||% ""

  if (is.null(url) && (!is.null(host) && !is.null(port) && !is.null(dbname)))
  {
    url_ <- paste0("jdbc:netezza://", host, ":", port, "/", dbname)
  }
  else {
    url_ <- url
  }
  
  con <- DBI:::dbConnect(driver, url = url_ %||% "", user = user %||% "",
    password = password %||% "", ...)

  .jcall(con@jc, "V", "setAutoCommit", FALSE)

  info <- list(url=url, user=user, driver=.jstrVal(con@jc))
  if (is.null(url)) {
    info$dbname <- dbname
    info$host <- host
    info$port <- port
  } 
  else 
  {
    # TODO parse the other information
    info$dbname <- stringr::str_extract(nz$info$url, "\\w+$") # extract the last "word" in the url string
  }

  src_sql("JDBC", con,
    info = info, disco = dplyr:::db_disconnector(con, "JDBC"))
}

#' @export
src_desc.src_JDBC <- function(x) 
{
  info <- x$info
  paste0(info$dbname, " [", info$user, "]")
}

#' @export
#' @rdname src_JDBC
tbl.src_JDBC <- function(src, from, ...) {
  tbl_sql("JDBC", src = src, from = from, ...)
}

#' @export
# TODO: fix for JDBC
brief_desc.src_JDBC <- function(x) {
  info <- x$info
  paste0("JDBC ", info$driver, " [", info$url, "]")
}

#' @export
src_translate_env.src_JDBC <- function(x) {
  sql_variant(
    base_scalar,
    sql_translator(.parent = base_agg,
      n = function() sql("count(*)")
    ),
    base_win
  )
}

# DB backend methods
#' @export
db_list_tables.JDBCConnection <- function(con) {
  DBI::dbListTables(con)
}

#' @export
db_has_table.JDBCConnection <- function(con, table) {
  table %in% db_list_tables(con)
}

#' @export
db_query_fields.JDBCConnection <- function(con, sql, ...)
{
  dbListFields(nz$con, sql)
}

