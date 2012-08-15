##' Make this a rook app
##'
##' To use this on Rhttpd$new(app_name="this", filename="that")
##' @param env env passed in by Rook
##' @return a list with components status, headers, body
##' 
app <- function(env) {

  request <- Request$new(env)
  status <- 200L

  ## route base on path info
  path <- request$path_info()
  router <- list("get_id"="get_id",
                 "create_ui"="create_ui",
                 "ajax_call"="ajax_call",
                 "proxy_call"="proxy_call",
                 "proxy_call_text"="proxy_call_text",
                 "file_upload"="file_upload")


  fun <- router[[gsub("^/", "", path)]]

  
  if(is.null(fun) && file.exists(path)) {
    ## use path_info to get file
    message("show ui.html")
    tpl <- system.file("templates", "ui.html", package="gWidgetsWWW2.rapache")
    tpl <- paste(readLines(tpl, warn=FALSE), collapse="\n")
    out <- whisker.render(tpl, list(the_script=path))
  } else {
    f <- getFromNamespace(fun, ns="gWidgetsWWW2.rapache")

    params <- request$POST() %||% request$GET() %||% NULL
    
    if(!is.null(params)) {
      ID <- params$ID
      out <- try(f(ID, params), silent=TRUE)
    } else {
      out <- try(f(), silent=TRUE)
    }
  }

  ## we return javascript?
  if(is(out, "Response")) {
    out$finish()
  } else if(inherits(out, "try-error")) {
    message("error")
    err_msg <- attr(out, "condition")$message
    response <- Response$new(status=400L)
    print(response)
    response$write(whisker.render("Error: {{{err_msg}}}"))
    return(response$finish())
  } else {
    response <- Response$new(status=status)
    response$write(out)
    return(response$finish())
  }
}


