##' @include gcomponent.R
NULL

##' make a tempfile that works through a url
##'
##' The svalue method returns the filename.
##' the \code{temp_file} url with \code{ {ID:ID,obj:obj} }, typically through a proxy call as with ghtml
##' @export
gtempfile <- function(fileext=".tmp", ...) {

  obj <- new_item()
  class(obj) <- c("GTempFile", "GComponent", class(obj))

  ## vals
  f <- tempfile(fileext=fileext)
  set_vals(obj, items=f)

  obj
}

##' svalue returns file name
svalue.GTempFile <- function(obj, ...) {
  get_items(obj)
}

##' set the file name
"svalue<-.GTempFile" <- function(obj, ..., value) {

  set_items(obj, value)
  obj
}



