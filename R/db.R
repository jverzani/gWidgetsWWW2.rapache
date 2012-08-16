##' @include json.R
##' @include utils.R
NULL


## data base stuff
db_name <- function(dbname)
  sprintf("/tmp/%s.db", dbname)


open_connection <- function(dbname=..ID..) {
  drv <- dbDriver("SQLite")
  
  f <- db_name(dbname)
  message("open connection ", f)
  db <- dbConnect(drv, dbname = f)

  db
}

disconnect_connect <- function(db) dbDisconnect(db)

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
  sql <- "insert into widgets (value, items, properties) values ('', '{}', '{}');"
  dbGetQuery(db, whisker.render(sql))

  sql <- "SELECT last_insert_rowid()"
  out <- dbGetQuery(db, whisker.render(sql))
  id <- out[1,1]

  id
  
}

set_vals <- function(id, value, items, properties) {
  db <- ..con..
  l <- list()
  if(!missing(value))
    l$value <- value
  if(!missing(items))
    l$items <- toJSON(items) #serialize(items, NULL)
  if(!missing(properties))
    l$properties <- toJSON(properties) #serialize(properties, NULL)

  dbBeginTransaction(db)
  mapply(function(key, value,  id) {
    sql <- whisker.render('update widgets set {{key}} = :value where id=:id')

    dbGetPreparedQuery(db, sql,
                       bind.data=data.frame(id=id, value=value,
                         stringsAsFactors=FALSE))
    
  }, names(l), l, id=id)
  dbCommit(db)
}


get_vals <- function(id, key=c("value", "items", "properties")) {
  db <- ..con..
  
  key <- match.arg(key)

  sql <- whisker.render('select {{key}} from widgets where id={{id}}')
  out <- dbGetQuery(db, sql)[,,drop=TRUE]

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

set_value <- function(obj, value) set_vals(obj, value=value)
set_items <- function(obj, value) set_vals(obj, items=value)
set_properties <- function(obj, value) set_vals(obj, properties=as.list(value))

update_property <- function(obj, key, value) {
  props <- get_properties(obj)
  props[[key]] <- value
  set_properties(obj, props)
}
