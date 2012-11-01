##' @include gradio.R
NA

## TODO names<- metdho

##' A group of checkboxes
##' 
##' @param items vector of items to select from
##' @param checked initial value of checked state. Recycled
##' @param horizontal Layout horizontally?
##' @param use.table Needs implementing. If TRUE, uses a grid widget with checkboxes to
##' display. If TRUE, horizontal is ignored, and items may be a data
##' frame.
##' @inheritParams gwidget
##' @return A \code{GCheckboxGroup} reference class instance
##' @export
##' @examples
##' w <- gwindow()
##' sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
##' cbg <- gcheckboxgroup(state.name[1:4], cont=w)
gcheckboxgroup = function (items, checked = FALSE, horizontal = TRUE,
  use.table=FALSE,
  handler = NULL, action = NULL,
  container = NULL, ...,
  width=NULL, height=NULL, ext.args=NULL,
  flex=1,
  label.width=10 + 10 * max(nchar(items)),
  columns=ifelse(horizontal,length(items), 1)) {


  obj <- new_item()
  class(obj) <- c("GCheckboxGroup", "GRadio", "GWidget", "GComponent", class(obj))

  ## vals: value is item, not index
  set_vals(obj, value=.to_string(items[rep(checked, length=length(items))]), items=items)
  
  ## js
  constructor <- "Ext.form.CheckboxGroup"
  args <- list(items=I(.items_as_array(obj, items, label.width)),
               width = width,
               height = height,
               vertical=!horizontal,
               columns=columns,
               defaults=list(flex=flex)
               )
  
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  ## set checked...
  checked <- rep(checked, length(items))
  set_value_js(obj, which(checked))
  
  ## add
  add(container, obj, ...)

  
  ## handlers
  addHandlerChanged(obj, handler=function(h, ...) {})
  if(!missing(handler)) 
    addHandlerChanged(obj, handler, action)

  obj
}

.to_string <- function(x) paste(x, collapse=":::")
.from_string <- function(x) strsplit(x, ":::")[[1]]

before_handler.GCheckboxGroup <- function(obj, signal, params,...) {
  ## we get indices posibbly empty we store values
  items <- get_items(obj)
  idx <- params$value
  if(length(idx) == 0)
    idx <- integer(0)
  set_value(obj, .to_string(items[idx]))
}

addHandlerChange.GCheckboxGroup <- function(obj, handler, action=NULL, ...) {

  oid <- o_id(obj)
  tpl <- "var params = {value: {{oid}}.getValue().{{oid}}_radio}"
  
  addHandler(obj, "change", handler, action, ...,
             params=whisker.render(tpl)
             )
}

##' svalue method
##' 
##' @rdname svalue
##' @method svalue GCheckboxGroup
##' @S3method svalue GCheckboxGroup
svalue.GCheckboxGroup <- function(obj, index=NULL, drop=NULL, ...) {
  items <- get_items(obj)
  vals <- .from_string(get_value(obj))
  index <- index %||% FALSE
  if(index) {
    idx <- match(vals, items)
    if(is.na(idx)) idx <- integer(0)
    return(idx)
  }
  return(vals)
}

##' assignment method for svalue
##' @method svalue<- GCheckboxGroup
##' @S3method svalue<- GCheckboxGroup
##' @rdname svalue_assign
"svalue<-.GCheckboxGroup" <- function(obj, index=NULL, ..., value) {
  if(is.logical(value)) {
    value <- which(value)
    index <- TRUE
  }
  items <- get_items(obj)
  
  index <- index %||% FALSE
  if(index) 
    set_value(obj, .to_string(items[index]))
  else
    set_value(obj, .to_string(value))

  if(!index)
    value <- match(value, items)

  set_value_js(obj, value)

  obj
}

## set, value are indices
set_value_js.GCheckboxGroup <- function(obj, value) {
  id <- sprintf("%s_radio", o_id(obj))
  call_ext(obj, "setValue", I(sprintf("{%s:%s}", id, toJSON(value))))
}


##' checkbox widget
##' 
##' @param text character. text label for checkbox. 
##' @param checked logical. initial state (Set later with \code{svalue<-})
##' @param use.togglebutton logical. XXX not implemented If TRUE, represent with a togglebutton, else use check box 
##' @inheritParams gwidget
##' @export
##' @note No method to set label
##' @examples
##' w <- gwindow()
##' sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
##' cb <- gcheckbox("Check me?", cont=w, handler=function(h,...) if(svalue(h$obj)) galert("checked", parent=w))
gcheckbox = function(text="", checked = FALSE, use.togglebutton=FALSE,
  handler = NULL, action = NULL,  container = NULL,...,
  width=NULL, height=NULL, ext.args=NULL) {

  obj <- gcheckboxgroup(text, checked=checked, handler=handler, action=action,
                        container=container, ...,
                        width=width, height=height, ext.args=ext.args)
  class(obj) <- c("GCheckbox", class(obj))

  obj

}

## difference is we use logicals here

##' svalue method
##' 
##' @rdname svalue
##' @method svalue GCheckbox
##' @S3method svalue GCheckbox
svalue.GCheckbox <- function(obj, value) {
  val <- NextMethod()
  ## return logical
  length(val) > 0
}
  
