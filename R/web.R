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
init_globals <- function() {
  ..e..$..queue.. <- character()
  ..e..$..handlers.. <- list(id=1L, blocked=character())
}

## push cmd to javascript queue
## uses global ..e.. to store queue
push_queue <- function(cmd) {
  ..e..$..queue.. <- c(..e..$..queue.., unlist(cmd))
  invisible(..e..$..queue..)
}


create_ui <- function(ID, params) {
  init_globals()
  the_script <- params$the_script # "/tmp/w.R"

  
  con <- open_connection(ID)
  on.exit()
  create_table(con)

  on.exit({
    disconnect_connect(con)
    init_globals()
  })

  e <- new.env()

  e$..con.. <- con

  
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

## return text (for ghtml)
proxy_call_text <- function(ID, params) {
  ## items is a filename with the text
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
  
  out <- paste(readLines(f, warn=FALSE), collapse="\n")

  return(out)

}



clean_up <- function(ID) {
  ## clean up files for ID
  message("clean up")
  unlink(db_name(ID))                   # data base
  unlink(get_e_name(ID))

  return("")
}
