##' @include gcomponent.R
NULL

## methods for containers
add <- function(parent, child, ...) UseMethod("add")
add.default <- function(parent, child, ...) {

  ## XXX process ...
  call_ext(parent, "add", o_id(child))
}

## return list with extra arguments for adding
add_dots <- function( ...) {
  args <- list(...)
  l <- list()

  if(!is.null(args$expand))
    l$flex <- as.numeric(args$expand)

  if(!is.null(args$fill) && args$fill)
    l$align <- "stretch"

  if(!is.null(args$label))
    l$fieldLabel <- args$label
  
  l
}


delete <- function(parent, child, ...) UseMethod("delete")
delete.default <- function(parent, child, ...) {
  call_ext(parent, "remove", o_id(child))
}


##
dispose <- function(obj, ...) UseMethod("dispose")
dispose.default <- function(obj, ...) {
  call_ext(obj, "destroy")
}

  
