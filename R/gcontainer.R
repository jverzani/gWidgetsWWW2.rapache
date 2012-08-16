##' @include gcomponent.R
NULL

## methods for containers
add <- function(parent, child, ...) UseMethod("add")
add.default <- function(parent, child, ...) {

  ## XXX process ...
  call_ext(parent, "add", o_id(child))
}

## return list with extra arguments for adding
add_dots <- function(obj, expand=NULL, fill=NULL, anchor=NULL, ...) UseMethod("add_dots")
add_dots.default <- function(obj, expand=NULL, fill=NULL, anchor=NULL,  ...) {
  args <- list(...)
  l <- list()

  if(!is.null(expand))
    l$flex <- as.numeric(expand)

  if(!is.null(fill) && fill)
    l$align <- "stretch"

  if(!is.null(args$label))
    l$fieldLabel <- args$label
  
  l
}
add_dots.GContainer <- function(obj, expand=NULL, fill=NULL, anchor=NULL, ...) {
  add_dots.default(obj, expand=expand, fill=fill, anchor=anchor)
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

  
