#' @export
tbl_sql <- function(subclass, src, from, ..., vars = attr(from, "vars")) {
  if (!is.sql(from)) { # Must be a character string
    assert_that(length(from) == 1)
    if (isFALSE(db_has_table(src$con, from))) {
      stop("Table ", from, " not found in database ", src$path, call. = FALSE)
    }
    
    from <- ident(from)
  } else if (!is.join(from)) { # Must be arbitrary sql
    # Abitrary sql needs to be wrapped into a named subquery
    from <- sql_subquery(src$con, from, unique_name())
  }

  tbl <- make_tbl(c(subclass, "sql"),
    src = src,              # src object
    from = from,            # table, join, or raw sql
    select = vars,          # SELECT: list of symbols
    summarise = FALSE,      #   interpret select as aggreagte functions?
    mutate = FALSE,         #   do select vars include new variables?
    where = NULL,           # WHERE: list of calls
    group_by = NULL,        # GROUP_BY: list of names
    order_by = NULL         # ORDER_BY: list of calls
  )
  update(tbl)
}



