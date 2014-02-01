## apache file for gWidgetsWWW2.rapache
## This file is used by `rapache` to dispatch the various requests


require(gWidgetsWWW2.rapache)
## we route based on path info
pi <- SERVER$path_info
content_type <- "text/html"

sink(tempfile())

params <- POST %||% GET %||% list()
out <- NULL
f <- NULL

if(grepl("get_id", pi)) {
  ## get ID for the page

  content_type <- "application/json"
  out <- gWidgetsWWW2.rapache:::get_id()

} else if(grepl("create_ui", pi)) {

  ## create page UI elements
  content_type <- "application/javascript"
  out <- gWidgetsWWW2.rapache:::create_ui(params$ID, params)

} else if(grepl("ajax_call", pi)) {
  ## process ajax call (transport, handler)

  content_type <- "application/javascript"
  out <- try(gWidgetsWWW2.rapache:::ajax_call(params$ID, params), silent=TRUE)
  
} else if(grepl("proxy_call_text", pi)) {
  ## proxy call for text (ghtml)
  
  out <- try(gWidgetsWWW2.rapache:::proxy_call_text(params$ID, params), silent=TRUE)
  
} else if(grepl("proxy_call", pi)) {
  ## proxy call for data (gtable, gcheckbox, ...)

  content_type <- "application/json"
  out <- try(gWidgetsWWW2.rapache:::proxy_call(params$ID, params), silent=TRUE)
  
} else if(grepl("static_file", pi)) {
  ## this returns a file, which we display
  #x <- gsub("/gw/", "", pi)             # GENERALIZE XXX
  x <- pi
  f <- try(gWidgetsWWW2.rapache:::static_file(x), silent=TRUE)
  
} else if(grepl("temp_file", pi)) {
  
  f <- try(gWidgetsWWW2.rapache:::temp_file(params$ID, params), silent=TRUE)
  
} else if(grepl("file_upload", pi)) {
  ## file upload

  if(is.null(FILES)) {
    ## failed upload
    ## This unfortunately does not give a graceful error message.

    content_type <- "application/json" 
    out <- toJSON(list(success=FALSE, reason="Data set is too large."))

  } else {
    path <- FILES[[1]]$tmp_name
    nm <- FILES[[1]]$name
    
    ## move file to "permanent" place
    tmp <- tempfile()
    file.rename(path, tmp)
    params$filepath <- tmp
    params$filename <- nm
    
    gWidgetsWWW2.rapache:::process_file_upload(params$ID, params)
    
    
    content_type <- "text/html"           # odd, but what extjs expects
    out <- toJSON(list(success=TRUE, file=nm))
  }
    
} else if(grepl("clean_up", pi)) {
  ## clean up on exit
  content_type <- "application/json"
  out <- try(gWidgetsWWW2.rapache:::clean_up(params$ID), silent=TRUE)
} else {
  ## main page

  x <- pi
  
  ## this can be modified if desired
  tpl <- ui_template <- getOption('gWidgetsWWW2.rapache::ui_template') %||%
    system.file("templates", "ui.html", package="gWidgetsWWW2.rapache")
  

  tpl <- paste(readLines(tpl, warn=FALSE), collapse="\n")
  out <- whisker.render(tpl, list(the_script=x, # name of file
                                  favicon=getOption('gWidgetsWWW2.rapache::favicon') %||%  "static_file/images/r-logo.png"
                                  ))
}
sink()

## finish up.
## We have out or f, but f may be an error
if(inherits(f, "try-error"))
  out <- f
if(is.null(out)) {
  ## f is a file name
  setContentType(gWidgetsWWW2.rapache:::get_content_type(f))
  ## instruct browser it can cache file if a static request
  if(grepl("static_file", pi))
    setHeader("Cache-Control", "public, s-maxage=3600, max-age=3600, must-revalidate")
  size <- file.info(f)$size
  sendBin(readBin(f, 'raw', n=size))
  DONE
} else  {
  setContentType(content_type)
  if(inherits(out, "try-error")) {
    ## what to do on an error??
    message(out) ## write to log file
  } else {
    cat(out)
  }
  OK
}
