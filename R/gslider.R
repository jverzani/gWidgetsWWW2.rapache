##' @include gspinbutton.R
NULL

##' slider widget
##'
##' Use slider to select from a sequence of values, specified as with
##' \code{seq}. The sequence steps must be greater than 1
##' @param from starting point. Unlike other implementations for
##' gWidgets, this is not possibly a vector specifying a range of
##' values to slide over.
##' @param to ending point
##' @param by step size. Must be larger than 1 and even then will round to integer value
##' @param value initial value
##' @param horizontal orientation
##' @inheritParams gwidget
##' @param tpl Template for tooltip. Should have "\code{{0}}" to replace the value, but can have more formatting
##' @note The slider updates on "changecomplete", not the more common
##' "change". The "change" signal happens too often for the
##' transferral of values to work reliably.  the database can process
##' so these should be used sparingly.
##' @export
gslider <- function(from = 0, to = 100, by = 1, value = from,
                    horizontal = TRUE,
                    handler = NULL, action = NULL, container = NULL, ...,
                    width=NULL, height=NULL, ext.args=NULL,
                    tpl = "{0}"
                    ) {



  
  obj <- new_item()
  class(obj) <- c("GSlider", "GSequenceSelect", "GWidget", "GComponent", class(obj))

  ## vals
  set_vals(obj, value=value,
           properties=list(coerce.with="as.numeric"))

  ## js
  constructor <- "Ext.slider.Single"

  ## template for slider
  tmpl <- "function(thumb) {return Ext.String.format('{{{tpl}}}', thumb.value)}"
  tipText <- whisker.render(tmpl)
  
  args <- list(value=value,
               minValue=from,
               maxValue=to,
               increment=by,
               vertical=!horizontal,
               useTips=TRUE,
               tipText=I(tipText),
               enableKeyEvents=TRUE,
               width = width,
               height = height,
               width=width,
               height=height
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


addHandlerChange.GSlider <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "changecomplete", handler, action, ...,
             params="var params = {value: newValue}")
}
