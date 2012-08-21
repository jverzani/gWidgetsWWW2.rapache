## apache file for gWidgetsWWW2.rapache


require(whisker)
require(RJSONIO)
require(RSQLite)

url_base <- getOption('gWidgetsWWW2.rapache::url_base') %||% "/custom/gw"

## we route based on path info
pi <- SERVER$path_info
content_type <- "text/html"

sink(tempfile())

params <- POST %||% GET %||% list()

out <- NULL

if(grepl("get_id", pi)) {
  ## get ID for the page

  content_type <- "application/json"
  out <- gWidgetsWWW2.rapache:::get_id()

} else if(grepl("create_ui", pi)) {

  ## create page UI elements
  content_type <- "text/javascript"
  out <- gWidgetsWWW2.rapache:::create_ui(params$ID, params)

} else if(grepl("ajax_call", pi)) {
  ## process ajax call (transport, handler)

  message("ajax call: ", capture.output(str(params)))
  
  content_type <- "text/javascript"
  out <- gWidgetsWWW2.rapache:::ajax_call(params$ID, params)
  
} else if(grepl("proxy_call_text", pi)) {
  ## proxy call for text (ghtml)
  
  out <- gWidgetsWWW2.rapache:::proxy_call_text(params$ID, params)
  
} else if(grepl("proxy_call", pi)) {
  ## proxy call for data (gtable, gcheckbox, ...)

  message("proxy_call post=", capture.output(str(params)))

  
  content_type <- "application/json"
  out <- gWidgetsWWW2.rapache:::proxy_call(params$ID, params)
  
} else if(grepl("static_file", pi)) {
  ## this returns a file, which we display
  x <- gsub("/gw/", "", pi)             # GENERALIZE XXX
  f <- gWidgetsWWW2.rapache:::static_file(x)
  
} else if(grepl("temp_file", pi)) {
  
  f <- gWidgetsWWW2.rapache:::temp_file(params$ID, params)
  
} else if(grepl("file_upload", pi)) {
  ## file upload
  XXX()
} else if(grepl("clean_up", pi)) {
  ## clean up on exit
  message("clean up:", params$ID)
  content_type <- "application/json"
  out <- gWidgetsWWW2.rapache:::clean_up(params$ID)
} else {
  ## main page

  x <- gsub("/gw/", "", pi)             # GENERALIZE XXX
  
  tpl <- system.file("templates", "ui.html", package="gWidgetsWWW2.rapache")
  tpl <- paste(readLines(tpl, warn=FALSE), collapse="\n")
  out <- whisker.render(tpl, list(the_script=x,
                                  url_base=url_base
                                  ))
}
sink()

## finish up.
## We have out or f
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
  cat(out)
  DONE
}
