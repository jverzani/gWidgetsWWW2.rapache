## apache file for gWidgetsWWW2.rapache


require(whisker)
require(RJSONIO)
require(RSQLite)

pi <- SERVER$path_info

## we route based on path info
content_type <- "text/html"

sink(tempfile())

params <- POST %||% GET %||% list()

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
  find_script <- function(pi) {
    x <- gsub("/gw/", "", pi)
    dirs <- getOption('gWidgetsWWW2.rapache::script_base') %||%
      c(system.file('examples', package='gWidgetsWWW2.rapache'))
    out <- Filter(function(x) file.exists(x) && !file.info(x)$isdir,
           paste(dirs, x, sep=.Platform$file.sep))
    if(length(out))
      return(out[1])
    else
      stop(sprintf("No such file found for %s", pi))
  }
        

  
  tpl <- system.file("templates", "ui.html", package="gWidgetsWWW2.rapache")
  tpl <- paste(readLines(tpl, warn=FALSE), collapse="\n")
  out <- whisker.render(tpl, list(the_script=find_script(pi)))
}
sink()

## finish up
setContentType(content_type)
cat(out)
DONE
