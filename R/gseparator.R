##' @include ghtml.R
NULL

##' Separator -- insert separator line
##'
##' Used in menus to create space. No container necessary
##' Can also be used to place horizontal  line using the \code{hr} HTML tag
##' 
##' @param horizontal Logical. Ignored, not vertical line possible
##' @param container parent container. Not used if creating menu or toolbar separator
##' @param ... passed to \code{add} method of parent container
##' @export
gseparator <- function(horizontal = TRUE, container = NULL, ...)  {
  if(is.null(container)) {
    ## menus
    s <- ""; class(s) <- "GSeparator"
    return(s)
  } else {
    obj <- ghtml("<hr />", container=container)
    class(obj) <- c("GSeparator", class(obj))
    obj
  }
}

