##' @include gcomponent.R
NULL

## TODO: width is wrong

##' gedit
##'
##' @export
gedit <- function(text, width=25, coerce.with=NULL, placeholder=NULL,
                  container, handler, action=NULL,
                  ..., ext.args=list()
                  ) {

  placeholder <- placeholder %||% list(...)$initial.msg %||% ""
  
  obj <- new_item()
  class(obj) <- c("GEdit", "GWidget", "GComponent", class(obj))

  ## vals
  set_vals(obj, value=text, items=list(coerce.with=coerce.with))


  ## js
  constructor <- "Ext.form.field.Text"
  args <- list(value=as.character(text),
                 enableKeyEvents=TRUE,
                 width=ifelse(is.character(width), width, sprintf("%spx", 8*width)),
                 emptyText=placeholder
                 )

  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  ## add
  add(container, obj, ...)


  
  ## handlers
  transport <- function(h,...) {}
  addHandlerChanged(obj, transport)
  
  if(!missing(handler)) 
    addHandlerChanged(obj, handler, action)

  obj
}

## handlers
before_handler.GEdit <- function(obj, signal, params, ...) {
  message("before handler:", capture.output(params))
   set_vals(obj, value=params$value)
}

addHandlerChanged.GEdit <- function(obj, handler, action=NULL, ...) {
  addHandlerBlur(obj, handler, action, ...)
}
              

addHandlerBlur.GEdit <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "blur", handler, action, ...,
             params="var params = {value: w.getValue()};"
             )
}

addHandlerEnter.GEdit <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "enter", handler, action, ...,
             params="var params = {value: w.getValue()};"
             )
}

               
