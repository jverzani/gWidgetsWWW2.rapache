##' @include json.R
##' @include utils.R
NULL


## data base stuff
## we have a global connection ..con.. that gets created in web.R

db_name <- function(dbname) {
  tmp_dir <- getOption("gWidgetsWWW2.rapache::tmp_dir") %||% "/tmp/gw"
  if(!(file.exists(tmp_dir) && file.info(tmp_dir)$isdir))
    dir.create(tmp_dir, recursive=TRUE)
  sprintf("%s/%s.db", tmp_dir, dbname)
}


open_connection <- function(dbname=..ID..) {
  drv <- dbDriver("SQLite")
  ## how to check if okay
  f <- db_name(dbname)
  db <- dbConnect(drv, dbname = f)
  db
}

disconnect_connect <- function(db) {
  dbDisconnect(db)
}

create_table <- function(db) {
  
  ## create table if not there
  sql <- "
create table if not exists widgets (id INTEGER PRIMARY KEY AUTOINCREMENT, value TEXT, items BLOB, properties BLOB)
"
  dbGetQuery(db, whisker.render(sql))
  
  db
}

bulk_insert <- function(db, sql, data) {
  dbBeginTransaction(db)
  dbGetPreparedQuery(db, sql, bind.data = data)
  dbCommit(db)
}

new_item <- function() {
  db <- ..con..
  bind.data <- data.frame(
                          value="",
                          items="",
                          properties=""
                          )
  sql <- "insert OR IGNORE into widgets (value, items, properties) values ('', '{}', '{}');"
  dbGetQuery(db, whisker.render(sql))

  sql <- "SELECT last_insert_rowid()"
  out <- dbGetQuery(db, whisker.render(sql))
  id <- out[1,1]

  id
  
}

set_vals <- function(id, value, items, properties, db=..con..) {
  l <- list()
  if(!missing(value))
    l$value <- value
  if(!missing(items))
    l$items <- toJSON(items)
  if(!missing(properties))
    l$properties <- toJSON(properties) 

  out <- try({
    dbBeginTransaction(db)
    tmp <- mapply(function(key, value,  id) {
      sql <- whisker.render('update OR IGNORE widgets set {{key}} = :value where id=:id')
      
      res <- dbGetPreparedQuery(db, sql,
                                bind.data=data.frame(id=id, value=value,
                                  stringsAsFactors=FALSE))
    }, names(l), l, id=id)

    dbCommit(db)
  }, silent=TRUE)

  if(inherits(out, "try-error"))
    message("Couldn't write to data base")
}


get_vals <- function(id, key=c("value", "items", "properties")) {
  db <- ..con..
  key <- match.arg(key)

  sql <- whisker.render('select {{key}} from widgets where id={{id}}')

  ctr <- 1
  out <- try(dbGetQuery(db, sql), silent=TRUE)
  if(inherits(out, "try-error")) {
    message("Couldn't get vals")
    stop()
  }
  ## while(inherits(out, "try-error")) {
  ##   Sys.sleep(.05)                      # 50ms
  ##   ctr <- ctr + 1
  ##   message("get vals, trying ctr=", ctr)
  ##   if(ctr >= 100) stop("Can't get lock on database file")
  ##   out <- try(dbGetQuery(db, sql), silent=TRUE)
  ## }

  

  out <- out[,,drop=TRUE]
  
  if(key %in% c("items", "properties")) {
    if(nchar(out)) {
      out <- fromJSON(out)
      if(key == "properties")
        out <- as.list(out)
    }
  }
  
  return(out)
}

## accessors
get_value <- function(obj) get_vals(obj, "value")
get_items <- function(obj) get_vals(obj, "items")
get_properties <- function(obj) get_vals(obj, "properties")
get_property <- function(obj, key) get_properties(obj)[[key]]

set_value <- function(obj, value) set_vals(obj, value=value)
set_items <- function(obj, value) set_vals(obj, items=value)
set_properties <- function(obj, value) set_vals(obj, properties=as.list(value))

update_property <- function(obj, key, value) {
  props <- get_properties(obj)
  props[[key]] <- value
  set_properties(obj, props)
}
