## Warning!!! There is some kludgy stuff going on here
## We use global variables to keep track of the queue and
## any defined handlers. These are ..queue.., ..handler..
## but we can't modify namespace global, so we use an environment ..e..
## makes for fun variable names, ..e..$..queue..
##
## The handlers and widgets are stored in an environment that is
## serialized and dumped to disk via rredis. Unlike gWidgetsWWW2 we
## *avoid* reference classes here, as they really don't like to be
## serialized this way. Instead we use the rredis data base to store
## values on the widgets. Makes for small -- and much quicker to
## deserialize -- environments storing the state.

tmp_dir <- getOption("gWidgetsWWW2.rapache::tmp_dir") %||% "/tmp"

new_item <- function() {
  get_id()
}

set_vals <- function(id, value=NULL, items=NULL, properties=NULL) {
##  message("set vals, id=", id, "value:", value, "items=", items, "properties=", names(properties))
  out <- redisGet(id)
  if(is.null(out)) {
    out <- list(value=value, items=items, properties=properties)
  } else {
    if(!is.null(value)) out$value <- value
    if(!is.null(items)) out$items <- items
    if(!is.null(properties)) out$properties <- properties
  }
  if(is.null(out))
    stop("set vals with null??" )
  redisSet(id, out)
}

get_vals <- function(id, key=c("value", "items", "properties")) {
  l <- redisGet(id)
  if(is.list(l))
    l[[match.arg(key)]]
  else
    NULL
}
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


## web interface
get_id <- function(...) {
  ## return an ID, wasn't happy with dashes.
  ## http://stackoverflow.com/questions/10492817/how-can-i-generate-a-guid-in-r
  baseuuid <- paste(sample(c(letters[1:6],0:9),30,replace=TRUE),collapse="")
  return(baseuuid)
}

get_e_name <- function(ID) sprintf("%s/%s.rds", tmp_dir, ID)

## get serialized environment
get_e <- function(ID) {
  ## get environment from hash!!!
  e <- readRDS(get_e_name(ID))
  e
}

## read and write to RDS file
lockfile_name <- function(ID) sprintf("%s.lock", get_e_name(ID))

set_lock <- function(ID) {
  cat("locked", file=lockfile_name(ID))
}

remove_lock <- function(ID) {
  unlink(lockfile_name(ID))
}

is_locked <- function(ID) {
  file.exists(lockfile_name(ID))
}

readRDSfile <- function(ID, lock=TRUE) {
  if(lock) {
    ctr <- 1
    while(is_locked(ID))  {
      Sys.sleep(.05)
      ctr <- ctr + 1
      if(ctr >= 100) stop("Can't get lock on file")
    }
    set_lock(ID)
  }
  readRDS(get_e_name)
}

saveRDSfile <- function(e, ID) {
  saveRDS(e, get_e_name(ID))
  on.exit(remove_lock(ID))
}

## globals
..e.. <- new.env()
..e..$..queue.. <- character()
..e..$..handlers.. <- list(id=1L, blocked=character())
..e..$..ID.. <- NULL

init_globals <- function() {
  ..e..$..queue.. <- character()
  ..e..$..handlers.. <- list(id=1L, blocked=character())
  ..e..$..ID.. <- NULL
}

## push cmd to javascript queue
## uses global ..e.. to store queue
push_queue <- function(cmd) {
  ..e..$..queue.. <- c(..e..$..queue.., unlist(cmd))
  invisible(..e..$..queue..)
}

## look for script in script_base or check for index.R
find_script <- function(x, dirs) {

  out <- Filter(function(x) file.exists(x) && !file.info(x)$isdir,
                paste(dirs, x, sep=.Platform$file.sep))
  if(length(out))
      return(out[1])
  else if(x != "index.R")
    find_script("index.R", dirs)
  else
    NULL
}

check_redis <- function() {
  ## is redis running?
  out <- try(redisCmd("ping"))
  if(inherits(out, "try-error"))
    redisConnect(timeout=21474836L)
}

## create the UI
create_ui <- function(ID, params) {
#  check_redis()
  
  init_globals()
  ..e..$..ID.. <- ID

    
  dirs <- getOption('gWidgetsWWW2.rapache::script_base') %||%
               c(system.file('examples', package='gWidgetsWWW2.rapache'))

  message("create_ui looking for", params$the_script)
  the_script <- find_script(params$the_script, dirs) 
  message("create_ui, found this: ", the_script)
  
  if(is.null(the_script))
    return(sprintf("alert('could not find file %s')", params$the_script))

  e <- new.env()
  e$ID <- ID

  attach(e); on.exit(detach(e))
  out <- sys.source(the_script, envir=e, keep.source=FALSE)


  e$..handlers.. <- ..e..$..handlers..          # store
  redisSet(ID, e)

  return(paste(..e..$..queue.., collapse="\n"))
}




ajax_call <- function(ID, params) {
  init_globals()
  ..e..$..ID.. <- ID  

  e <- redisGet(ID)
  ## add global handlers object, may be added in call
  ..e..$..handlers.. <- e$..handlers..

  obj <- params$obj
  signal <- params$signal
  params <- as.list(fromJSON(params$params %||% "{}"))

  e$ID <- ID

  attach(e); on.exit(detach(e))

  ## call the handler
  out <- call_handler(obj, signal, params)
  ## might have modified global
  e$..handlers.. <- ..e..$..handlers..  

  redisSet(ID, e)
  return(paste(..e..$..queue.., collapse="\n"))
}


proxy_call <- function(ID, params) {

  e <- redisGet(ID)
  attach(e); on.exit(detach(e))
  
  f <- get_vals(params$obj, "items")
  items <- read.table(f)
  
  ## pump in row_id for tracking sorting, ...
  items <- cbind(row_id=seq.int(length.out=nrow(items)), items)
  
  ## visible
  vis <- get_properties(params$obj)$visible # NULL or logical of length nrow(items)

  if(!is.null(vis) && is.logical(vis) && length(vis) == nrow(items)) {
    items <- items[vis, , drop=FALSE]
  }
  
  ## reduce items by params
  ind <- NULL
  if(!is.null(params$start)) {
    m <- nrow(items)
    start <- as.numeric(params$start) + 1
    limit <- as.numeric(params$limit)

    ind <- seq_len(m)
    if(m > 0 && m >= start) {
      ind <- seq(start, min(m, start+limit))
    }
  }
 if(!is.null(params$sort)) {
    ## make a list
    sort_info <- as.list(unlist(fromJSON(params$sort)))
    direction <- c(ASC=FALSE, DESC=TRUE)
    
    x <- items[, sort_info$property]
    ordered <- order(x,
                     decreasing=if(sort_info$direction == "ASC") FALSE else TRUE
                     )
    
    ind <- ordered[ind]

  }
  if(!is.null(ind))
    items <- items[ind,, drop=FALSE] 

  ## go over rows, not columns
  out <- paste(lapply(seq_len(nrow(items)), function(i) toJSON(items[i,, drop=FALSE])), collapse=",")
  return(sprintf("[%s]", out))

}


temp_file <- function(ID, params) {

  ## get environment from hash!!!
  e <- redisGet(ID)
  attach(e); on.exit(detach(e))
  
  f <- get_vals(params$obj, "items")
  
  return(f)

}


## return text (for ghtml)
proxy_call_text <- function(ID, params) {
  f <- temp_file(ID, params)
  
  out <- paste(readLines(f, warn=FALSE), collapse="\n")

  return(out)

}

## return the filename
static_file <- function(x) {
  message("Calling static file with: ", x)
  ##
  x <- gsub("static_file/", "", x)
  dirs <- system.file("extra", package="gWidgetsWWW2.rapache")
  f <- find_script(x, dirs)

  if(is.null(f))
    message("static file: did not find script in ", dirs)
  else
    message("static file, we found ", f)
  
  if(is.null(f))
    stop(sprintf("Can't find file %s", x))
  f
}

process_file_upload <- function(ID, params) {
  path <- params$filepath
  nm <- params$filename

  e <- redisGet(ID)
  attach(e)
  out <- set_vals(params$obj, value=path, items=nm) ## wrap in try?
  detach(e)

  redisSet(ID, e)

  return(TRUE)

}

clean_up <- function(ID) {
  e <- redisGet(ID)
  lapply(e, function(obj) {
    if(is(obj, "GComponent")) {
      redisDelete(as.character(obj))
    }
  })
  redisDelete(ID)
}
