##' @include gcomponent.R
NULL

##' calendar widget
##'
##' Basic text box with button to open calendar picker dialog. The
##' svalue method refers to the date, which depends on the value of
##' \code{format}.
##' @param text optional inital date as text.
##' @param format format of date. Default of Y-m-d.
##' @inheritParams gwidget
##' @return a \code{GCalendar} instance
##' @note the \code{svalue} method returns an instance of \code{Date}
##' class by conversion through \code{as.Date}.
##' @export
##' @examples
##' w <- gwindow("Calendar")
##' sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
##' a <- gcalendar(cont=w)
gcalendar <- function(text = "", format = NULL,
                      handler=NULL, action=NULL, container = NULL, ...,
                      width=NULL, height=NULL, ext.args=NULL
                      ) {

  obj <- new_item()
  class(obj) <- c("GCalendar", "GWidget", "GComponent", class(obj))

  ## vals
  date_format <- format %||% "%Y-%m-%d"
  set_vals(obj,
           value="2012-02-02",
           properties=list(date_format=date_format)
           )

  
  ## js
  constructor <- "Ext.form.field.Date"
  args <- list(editable=TRUE,
               width=width,
               height=height,
               format=gsub("%", "", date_format)
               )
               
  if(nchar(text))
    svalue(obj) <- text
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  ## handlers
  addHandlerChanged(obj, function(h,...) {})
  if(!is.null(handler))
    addHandlerChanged(obj, hander, action, ...)

  
  ## add
  add(container, obj, ...)

  obj
}

before_handler.GCalendar <- function(obj, signal, params) {
  date_format <- get_properties(obj)$date_format
  set_value(obj, as.character(as.Date(params$value, date_format)))
}

##' svalue method
##' 
##' @rdname svalue
##' @method svalue GCalandar
##' @S3method svalue GCalandar
svalue.GCalendar <- function(obj, ...) {
  val <- get_vals(obj, "value")
  date_format <- get_properties(obj)$date_format
  as.Date(val, format=date_format)
}


##' assignment method for svalue
##' @method svalue<- GCalandar
##' @S3method svalue<- GCalandar
##' @rdname svalue_assign
"svalue<-.GCalendar" <- function(obj, ..., value) {
  date_format <- get_properties(obj)$date_format
  val <- as.Date(value, format=date_format)
  set_value(obj, as.character(val))
  set_value_js(obj, as.character(val))

  obj
}

set_value_js.GCalendar <- function(obj, value) {
  call_ext(obj, "setValue", value)
}

addHandlerChanged.GCalendar <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "change", handler, action, ...,
             params="var params = {value: newValue}")
}
