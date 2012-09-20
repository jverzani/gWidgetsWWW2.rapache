##' @include utils.R
NULL


## methods

##' Return main value associated with a widget
##'
##' @param x the widget
##' @param index if specified as \code{TRUE} calls \code{get_index}, else
##' @param drop passed along, in many cases used like \code{drop} call for \code{[}.
##' \code{get_value} reference methods.
##' @param ... passed to \code{get_value} or \code{get_index}
##' method. May include arguments \code{index} or \code{drop}
##' @export
svalue <- function(obj, index=NULL, drop=NULL, ...) UseMethod("svalue")

##' svalue method
##' 
##' @rdname svalue
##' @method svalue default
##' @S3method svalue default
svalue.default <- function(obj, index=NULL, drop=NULL, ...) {
  index <- index %||% FALSE
  value <- get_vals(obj, "value")
  
  if(!is.null(index) && index) {
    items <- obj[]
    if(!is.null(dim(items)))
      items <- items[,1,drop=TRUE]
    value <- match(value, items)
  } else if(!is.null(coerce_with <- get_properties(obj)$coerce.with)) {
    value <- match.fun(coerce_with)(value)
  }
  value
}


## we store value -- not index Use matching to get index
##' Set main value associated with a widget
##'
##' @param x object
##' @param index if non-NULL and \code{TRUE} call \code{set_index}
##' else call \code{set_value} reference class method.
##' @param ... passed to \code{set_value} method. May include
##' arguments for \code{index}
##' @param value value to set
##' @export 
##' @rdname svalue_assign
"svalue<-" <- function(obj, index=FALSE,  ..., value) UseMethod("svalue<-")

##' assignment method for svalue
##' @method svalue<- default
##' @S3method svalue<- default
##' @rdname svalue_assign
"svalue<-.default" <- function(obj, index=FALSE, ..., value) {
  index <- index %||% FALSE
  if(!is.null(index) && index) {
    items <- obj[]
    if(!is.null(dim(items))) {
      value <- items[value, 1, drop=TRUE]
    } else {
      value <- items[value]
    }
  }

  set_value(obj, value)
  set_value_js(obj, value)
  
  obj
}

## set JS. Here so that we can override
set_value_js <- function(obj, value) UseMethod("set_value_js")
set_value_js.default <- function(obj, value)   {
  if(is.character(value))
    value <- shQuote(paste(value, collapse="\n"))
  call_ext(obj, "set", value)
}
  
##' Method for [
##' @param x object
##' @param i row index
##' @param j column index
##' @param ... passed along
##' @param drop to [
##' @method [ GComponent
##' @S3method [ GComponent
##' @rdname bracket
"[.GComponent" <- function(x, i, j, ... , drop = FALSE) {
  items <- get_vals(x, "items")
  if(!is.null(dim(items)))
    items[i, j, drop=drop]
  else
    items[i]
}

##' assignment method for "["
##' @param x objecct
##' @param i row
##' @param j column
##' @param ... passed along
##' @param value passed to \code{set_items}
##' @method [<- GComponent
##' @S3method [<- GComponent
##' @rdname bracket_assign
"[<-.GComponent" <- function(x, i, j, ..., value) {
  set_vals(x, items=value)

  x
}





##' Primarily used to set if widget is shown, but also has other meanings
##'
##' @param x object Calls objects \code{set_visible} method
##' @param value logical
##' @export 
##' @rdname visible_assign
"visible<-" <- function(obj, value) UseMethod("visible<-")

##' assignment method for visible
##'
##' @method visible<- default
##' @S3method visible<- default
"visible<-.default" <- function(obj, value) {
  properties <- get_vals(obj, "properties")
  properties$visible <- value
  set_vals(obj, properties=properties)
  call_ext(obj, "setVisible", ifelse(value, "true", "false"))

  obj
}


##' Generically returns if widget is in visible state
##'
##' @param x object Calls objects \code{set_visible} method
##' @export 
visible <- function(obj) UseMethod("visible")

##' getters method for visible
##'
##' @rdname visible
##' @method visible default
##' @S3method visible default
visible.default <- function(obj) {
  properties <- get_vals(obj, "properties")
  properties$visible %||% FALSE
}

##' Set if widget is enabled
##'
##' @param x widget
##' @param value logical
##' @export 
##' @rdname enabled_assign
"enabled<-" <- function(obj, value) UseMethod("enabled<-")

##' assignment method for enabled
##' @method enabled<- default
##' @S3method enabled<- default
##' @rdname enabled_assign
"enabled<-.default" <- function(obj, value) {
  properties <- get_vals(obj, "properties")
  properties$enabled <- value
  set_vals(obj, properties=properties)
  call_ext(obj, if(value) "enable" else "disable")

  obj
}

##' Set focus onto object. 
##'
##' For some widgets, this sets user focus (e.g. gedit gets focus for
##' typing).
##' @param x object
##' @param value logical. Set focus state.
##' @export
##' @rdname focus
"focus<-" <- function(obj, value) UseMethod("focus<-")

##' Basic S3 method for focus
##'
##' @export
##' @rdname focus
##' @method focus<- default
##' @S3method focus<- default
"focus<-.default" <- function(obj, value) {
  properties <- get_vals(obj, "properties")
  properties$focus <- value
  set_vals(obj, properties=properties)
  if(value)
    call_ext(obj, "focus")

  obj
}

## size
set_width <- function(obj, px) UseMethod("set_width")
set_width.default <- function(obj, px) 
  call_ext(obj, "setWidth", px)

set_height <- function(obj, px) UseMethod("set_height")
set_height.default <- function(obj, px) 
  call_ext(obj, "setHeight", px)


##' Set size property, if implemented
##'
##' @param x widget
##' @param ... passed on 
##' @param value size specification, for most widgets a pair c(width, height), but can have exceptions
##' @export 
##' @rdname size_assign
"size<-" <- function(obj, value) UseMethod("size<-")


##' assignment method for size
##' @method size<- default
##' @S3method size<- default
##' @rdname size_assign
"size<-.default" <- function(obj, value) {
  if(!is.list(value)) {
    nms <- c("width", "height")[seq_along(value)]
    value <- setNames(as.list(value), nms)
  }
  width <- value$width; height <- value$height
  
  if(is.null(width)) return(set_height(obj, height))
  if(is.null(height)) return(set_width(obj, width))

  if(is.numeric(width)) return(call_ext(obj, "setSize", sprintf("%s,%s", width, height)))
  else return(call_ext(obj, "setSize", list(width=width, height=height)))


  obj
}


##
##' Set a tooltip for the widget
##'
##' @param x object
##' @param value character tooltip value
##' @export
##' @rdname tooltip
"tooltip<-" <- function(obj, value) UseMethod("tooltip<-")

##' Basic S3 method for tooltip<-
##'
##' @export
##' @rdname tooltip
##' @method tooltip<- default
##' @S3method tooltip<- default
"tooltip<-.default" <- function(obj, value) {
  call_ext(obj, "setTooltip", shQuote(value))

  obj
}


##' length method for GComponent's
##'
##' @param x object
##' @return length of object, loosely interpreted
##' @method length GComponent
##' @S3method length GComponent
length.GComponent <- function(x) length(get_items(x))
