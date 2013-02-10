##' @include utils.R
##' @include gcomponent.R
NULL

##' A text area widget
##'
##' XXX: there is an issue with single quotes.
##' @param text initial text. There is an issue with single quotes -- avoid them.
##' @param width width in pixels
##' @param height height in pixels
##' @param font.attr Ignored. Default font attributes
##' @param wrap Ignored Do we wrap the text
##' @inheritParams gwidget
##' @return an ExtWidget instance
##' @export
##' @examples
##' w <- gwindow("gtext example")
##' sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)
##' g <- ggroup(cont=w, horizontal=FALSE)
##' txt <- gtext("Some text with \n new lines", cont=g)
##' b <- gbutton("click", cont=g, handler=function(h,...) {
##'   galert(svalue(b), parent=w)
##' })
##'  b <- gbutton("change", cont=g, handler=function(h,...) {
##'    svalue(txt) <- "some new text"
##' })
gtext <- function(text = "", width = NULL, height = 300,
                  font.attr = NULL, wrap = TRUE,
                  handler = NULL, action = NULL, container = NULL,...,
                  ext.args=NULL,
                  grow=FALSE            # TRUE to automatically resize
                  ) {

    
  obj <- new_item()
  class(obj) <- c("GText",  "GWidget", "GComponent", class(obj))

  ## vals
  set_value(obj, text)

  
  ## js
  constructor <- "Ext.form.field.TextArea"
  args <- list(
               grow=grow,
               selectOnFocus = TRUE,
               enableKeyEvents=TRUE
               )
  if(grow) {
    args$growMax <- height
  } else {
    args$width <- width; args$height <- height
  }
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  ## add
  add(container, obj, ...)

  set_value_js(obj, text)
  
  ## handlers
  addHandlerChanged(obj, function(...) {}) # transport
  if(!missing(handler)) 
    addHandlerChanged(obj, handler, action)

  obj
}



insert <- function(obj, value, where=c("beginning", "end"),
                   do.newline=TRUE) {

  old_value <- get_value(obj)
  where <- match.arg(where)
  sep <- if(do.newline) "\n" else " "
  if(beginning)
    svalue(obj) <- paste(value, old_value, collapse=sep)
  else
    svalue(obj) <- paste(old_value, value, collapse=sep)
  
}


set_value_js.GText <- function(obj, value) {
  tpl <- '
  {{{oid}}}.setRawValue(\'{{{value}}}\');
'
  oid <- o_id(obj)
  value <- I(our_escape(value, type="single"))
  push_queue(whisker.render(tpl))
}

before_handler.GText <- function(obj, signal, params, ...) {
  if(!missing(params) && !is.null(params$value))
    set_value(obj, as.character(params$value))
}

##'  blur event
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerBlur GText
##' @S3method addHandlerBlur GText
addHandlerBlur.GText <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "blur", handler, action, ...,

             params = "var params={value:this.getValue()}"
             )
}

##'  changed event
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerChanged GTable
##' @S3method addHandlerChanged GTable
addHandlerChanged.GText <- addHandlerBlur.GText
