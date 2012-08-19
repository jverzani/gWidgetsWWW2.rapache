##' @include utils.R
##' @include gcomponent.R
NULL

##' A text area widget
##'
##' XXX: there are issues with new lines when setting text
##' @param text initial text
##' @param width width in pixels
##' @param height height in pixels
##' @param font.attr Ignored. Default font attributes
##' @param wrap Ignored Do we wrap the text
##' @inheritParams gwidget
##' @return an ExtWidget instance
##' @export
##' @examples
##' w <- gwindow("gtext example")
##' sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
##' g <- ggroup(cont=w, horizontal=FALSE)
##' t <- gtext("Some text with \n new lines", cont=g)
##' b <- gbutton("click", cont=g, handler=function(h,...) {
##'   galert(svalue(b), parent=w)
##' })
##'  b <- gbutton("change", cont=g, handler=function(h,...) {
##'    svalue(t) <= "some new text"
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
               width="100%", #width,
               height="100%", #height,
               grow=grow,
               selectOnFocus = TRUE,
               enableKeyEvents=TRUE #,
               ## loader=list( ## THis didn't work
               ##   url="/custom/gw/proxy_call_text",
               ##   #autoLoad=TRUE,
               ##   params=list(ID=I("ID"), obj=as.character(obj)), ## this is issue!
               ##   renderer=I("function(loader, response, active) {
               ##    loader.getTarget().update(response.responseText)
               ##  }")
               ##   )
               )
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  set_value_js(obj, text)
  ## add
  add(container, obj, ...)

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
  {{{oid}}}.setRawValue("{{{value}}}");
'
  oid <- o_id(obj)
#  value <- shQuote(escape_slashn(value)) #our_escape(value, type="double")
  value <- I(our_escape(value))
#  value <- I(sprintf("\"%s\"",gsub("\\n", "\\\\n", escape_double_quote(value))))
  push_queue(whisker.render(tpl))
}

before_handler.GText <- function(obj, signal, params, ...) {
  if(!missing(params) && !is.null(params$value))
    set_value(obj, as.character(params$value))
}


addHandlerBlur.GText <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "blur", handler, action, ...,

             params = "var params={value:this.getValue()}"
             )
}
addHandlerChanged.GText <- addHandlerBlur.GText
