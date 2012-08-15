##' @include utils.R
NULL


## methods
"svalue<-" <- function(obj, index=FALSE,  ..., value) UseMethod("svalue<-")
"svalue<-.default" <- function(obj, index=FALSE, value) {
  index <- index %||% FALSE

  if(index) {
    items <- get_vals(obj, "items")
    value <- items[value]
  }
  set_vals(obj, value=value)  
  set_value_js(obj, value)
  obj
}

## set JS. Here so tat we can override
set_value_js <- function(obj, value) UseMethod("set_value_js")
set_value_js.default <- function(obj, value)   {
  call_ext(obj, "set", value)
}
  

svalue <- function(obj, index=NULL, drop=NULL, ...) UseMethod("svalue")
svalue.default <- function(obj, index=NULL, drop=NULL, ...) {
  index <- index %||% FALSE
  value <- get_vals(obj, "value")
  if(index) {
    items <- get_vals(obj, "items")
    value <- match(value, items)
  }
  value
}


"[.GComponent" <- function(x, i, j, ... , drop = FALSE) {
  items <- get_vals(x, "items")
  items[i, j, drop=drop]
}

"[<-.GComponent" <- function(x, i, j, ..., value) {
  set_vals(x, items=value)

  x
}






"visible<-" <- function(obj, value) UseMethod("visible<-")
"visible<-.default" <- function(obj, value) {
  properties <- get_vals(obj, "properties")
  properties$visible <- value
  set_vals(obj, properties=properties)
  call_ext(obj, "setVisible", ifelse(value, "true", "false"))

  obj
}

visible <- function(obj) UseMethod("visible")
visible.default <- function(obj) {
  properties <- get_vals(obj, "properties")
  properties$visible %||% FALSE
}


"enabled<-" <- function(obj, value) UseMethod("enabled<-")
"enabled<-.default" <- function(obj, value) {
  properties <- get_vals(obj, "properties")
  properties$enabled <- value
  set_vals(obj, properties=properties)
  call_ext(obj, if(value) "enable" else "disable")

  obj
}


"focus<-" <- function(obj, value) UseMethod("focus<-")
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

"size<-" <- function(obj, value) UseMethod("size<-")
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
"tooltip<-" <- function(obj, value) UseMethod("tooltip")
"tooltip<-.default" <- function(obj, value) {
  call_ext(obj, "setTooltip", shQuote(value))

  obj
}
