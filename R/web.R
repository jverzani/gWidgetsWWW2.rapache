## Warning!!! There is some kludgy stuff going on here
## We use global variables to keep track of the queue and
## any defined handlers. These are ..queue.., ..handler..
## but we can't modify namespace global, so we use an environment ..e..
## makes for fun variable names, ..e..$..queue..
##
## The handlers and widgets are stored in an environment that is serialized and
## dumped to disk via saveRDS. Unlike gWidgetsWWW2 we *avoid* reference classes
## here, as they really don't like to be serialized this way. Instead
## we use an RSQLite data base to store values on the widgets, so they are
## just integers with extra class attributes. Makes for small -- and much quicker
## to deserialize -- environments storing the state.

## web interface
get_id <- function(...) {
  ## return an ID
  paste(sample(LETTERS, 10, TRUE), collapse="")
}

get_e_name <- function(ID) sprintf("/tmp/%s.rds", ID)

## get serialized environment
get_e <- function(ID) {
  ## get environment from hash!!!
  e <- readRDS(get_e_name(ID))
  e
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

## look for script in script_base
find_script <- function(x, dirs) {

  out <- Filter(function(x) file.exists(x) && !file.info(x)$isdir,
                paste(dirs, x, sep=.Platform$file.sep))
  if(length(out))
      return(out[1])
  else
    NULL
}

create_ui <- function(ID, params) {
  init_globals()
  ..e..$..ID.. <- ID
  
  dirs <- getOption('gWidgetsWWW2.rapache::script_base') %||%
               c(system.file('examples', package='gWidgetsWWW2.rapache'))
  
  the_script <- find_script(params$the_script, dirs) # "/tmp/w.R"

  if(is.null(the_script))
    return(sprintf("alert('could not find file %s')", params$the_script))
  
  con <- open_connection(ID)
  on.exit()
  create_table(con)

  on.exit({
    disconnect_connect(con)
    init_globals()
  })

  e <- new.env()

  e$..con.. <- con
  e$ID <- ID
  
  attach(e)
  out <- try(sys.source(the_script, envir=e, keep.source=FALSE), silent=FALSE)
  detach(e)

  e$..handlers.. <- ..e..$..handlers..          # store
  saveRDS(e, file=sprintf("/tmp/%s.rds", ID))

  
  return(paste(..e..$..queue.., collapse="\n"))
}
  

ajax_call <- function(ID, params) {
  message("ajax call")
  init_globals()
  ..e..$..ID.. <- ID  

  con <- open_connection(ID)
  create_table(con)

  on.exit({
    disconnect_connect(con)
    init_globals()
  })


  e <- get_e(ID)
  e$..con.. <- con
  ## add global handlers object, may be added in call
  ..e..$..handlers.. <- e$..handlers..

  obj <- params$obj
  signal <- params$signal
  params <- as.list(fromJSON(params$params %||% "{}"))

  e$ID <- ID  
  attach(e)
  out <- try(call_handler(obj, signal, params), silent=FALSE)
  detach(e)

  e$..handlers.. <- ..e..$..handlers..          # store
  saveRDS(e, file=sprintf("/tmp/%s.rds", ID))

  return(paste(..e..$..queue.., collapse="\n"))

}

## handle table requests
## use reader="json"
proxy_call <- function(ID, params) {
  message("proxy call, ID=", ID)

  
  con <- open_connection(ID)
  create_table(con)

  on.exit({
    disconnect_connect(con)
    init_globals()
    detach(e)
  })

  
  ## get environment from hash!!!
  e <- get_e(ID)
  e$..con.. <- con

  ## items is file name with text
  attach(e)                             # needed for getting value
  f <- get_vals(params$obj, "items")

  items <- read.table(f)
  ## reduce items by params
  if(!is.null(params$start)) {
    m <- nrow(items)
    start <- as.numeric(params$start) + 1
    limit <- as.numeric(params$limit)

    ind <- seq_len(m)
    if(m > 0 && m >= start) {
      ind <- seq(start, min(m, start+limit))
    }
    items <- items[ind, ,drop=FALSE]
  }
  if(!is.null(params$sort)) {
    ## make a list
    sort_info <- as.list(unlist(fromJSON(params$sort)))
    direction <- c(ASC=FALSE, DESC=TRUE)
    
    x <- df[, sort_info$property]
    ordered <- order(x,
                     decreasing=if(sort_info$direction == "ASC") FALSE else TRUE
                     )
    
    ind <- ordered[ind]
    items <- items[ind,, drop=FALSE]
  }

  ## go over rows, not columns
  out <- paste(lapply(seq_len(nrow(items)), function(i) toJSON(items[i,])), collapse=",")
  return(sprintf("[%s]", out))
}

## return the filename
temp_file <- function(ID, params) {
  ## items is a filename with the item
  con <- open_connection(ID)
  create_table(con)

  on.exit({
    disconnect_connect(con)
    init_globals()
    detach(e)
  })

  
  ## get environment from hash!!!
  e <- get_e(ID)
  e$..con.. <- con

  attach(e)
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
  ##
  x <- gsub("static_file/", "", x)
  dirs <- system.file("extra", package="gWidgetsWWW2.rapache")
  f <- find_script(x, dirs)
  if(is.null(f))
    stop(sprintf("Can't find file %s", x))
  f
}

process_file_upload <- function(ID, params) {
  path <- params$filepath
  nm <- params$filename

  message("upload Params", capture.output(print(params)))
  
  con <- open_connection(ID)
  e <- get_e(ID)
  e$..con.. <- con

  attach(e)
  out <- try(set_vals(params$obj, value=path, items=nm), silent=FALSE)
  detach(e)
  e$..con.. <- NULL
  saveRDS(e, file=sprintf("/tmp/%s.rds", ID))
  
  return(TRUE)
}

clean_up <- function(ID) {
  ## clean up files for ID
  message("clean up")
  unlink(db_name(ID))                   # data base
  unlink(get_e_name(ID))

  return("")
}
