##' @include gcomponent.R
NULL

##' Basic spinbutton
##'
##' @param from from value
##' @param to to
##' @param by by. From to by are same as seq() usage
##' @param value initial value
##' @inheritParams gwidget
##' @return an GSpinbutton reference class instance
##' @export
##' @examples
##' w <- gwindow()
##' sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
##' sp <- gspinbutton(cont=w)
gspinbutton <- function(from = 0, to = 100, by = 1, value = from,
                        handler = NULL, action = NULL, container = NULL, ...,
                        width=NULL, height=NULL, ext.args=NULL
                        ) {

  obj <- new_item()
  class(obj) <- c("GSpinButton", "GSequenceSelect", "GWidget", "GComponent", class(obj))

  ## vals
  set_vals(obj, value=value,
           properties=list(coerce.with="as.numeric"))

  
  ## js
  constructor <- "Ext.form.field.Number"
  args <- list(value=value,
               minValue=from,
               maxValue=to,
               step=by
               )
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  ## add
  add(container, obj, ...)

  
  ## handlers
  addHandlerChanged(obj, function(...) {}) # transfer
  if(!missing(handler)) 
    addHandlerChanged(obj, handler, action)

obj
}


set_value_js.GSequenceSelect <- function(obj, value) {
  call_ext(obj, "setValue", as.numeric(value))
}

before_handler.GSequenceSelect <- function(obj, signal, params) {
  set_value(obj, as.numeric(params$value))
}

##'  changed event
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerChanged GSequenceSelect
##' @S3method addHandlerChanged GSequenceSelect
addHandlerChanged.GSequenceSelect <- function(obj, handler, action=NULL, ...) {
  addHandlerChange(obj, handler, action, ...)
}

##'  changed event
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerChange GSequenceSelect
##' @S3method addHandlerChange GSequenceSelect
addHandlerChange.GSequenceSelect <- function(obj, handler, action=NULL, ...) {
addHandler(obj, "change", handler, action, ...,
           params="var params = {value: newValue}")
}
