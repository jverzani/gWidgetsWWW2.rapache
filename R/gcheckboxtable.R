##' @include gcomponent.R
NULL

##' Default to gtable with 'checkbox' selection. 
gcheckboxtable <- function(items, handler=NULL, action=NULL, container, ...,
                           width=NULL, height=NULL, ext.args=list()) {


  obj <- gtable(items, selection="multiple", handler=handler, action=action, container=container, ..., width=width, height=height, ext.arg=ext.arg)
  class(obj) <- c("GCheckboxTable", class(obj))
  
}

##' assignment method for svalue
##' @method svalue<- GCheckboxTable
##' @S3method svalue<- GCheckboxTable
##' @rdname svalue_assign
"svalue<-.GCheckboxTable" <- function(obj, index=NULL, ..., value) {
  if(is.logical(value)) {
    value <- which(value)
    index <- TRUE
  }
  NextMethod()
}
