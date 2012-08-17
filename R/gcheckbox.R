##' @include gradio.R
NA


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
gcheckboxgroup = function (items, checked = FALSE, horizontal = FALSE,
  use.table=FALSE,
  handler = NULL, action = NULL,
  container = NULL, ...,
  width=NULL, height=NULL, ext.args=NULL,
  flex=1,
  columns=ifelse(horizontal,length(items), 1)) {


  obj <- new_item()
  class(obj) <- c("GCheckboxGroup", "GRadio", "GWidget", "GComponent", class(obj))

  ## vals: value is item, not index
  set_vals(obj, value=items[rep(checked, length=length(items))], items=items)
  
  ## js
  constructor <- "Ext.form.CheckboxGroup"
  args <- list(items=I(.items_as_array(obj, items)),
               width = width,
               height = height,
               vertical=!horizontal,
               columns=columns,
               defaults=list(flex=flex)
               )
  
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  ## set checked...  
  ## add
  add(container, obj, ...)

  
  ## handlers
#  addHandlerChanged(obj, handler=function(h, ...) {})
  if(!missing(handler)) 
    addHandlerChanged(obj, handler, action)

  obj
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


  obj <- new_item()
  ## inherit handlers from GRadio
  class(obj) <- c("GCheckbox", "GRadio", "GWidget", "GComponent", class(obj))

  ## vals
  set_vals(obj, value=checked)

  
  ## js
  constructor <- "Ext.form.CheckboxGroup"
  args <- list(items=.items_as_array(text),
               width=width, height=height
               )
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  ## add
  add(container, obj, ...)

  
  ## handlers
  if(!missing(handler)) 
    addHandlerChanged(obj, handler, action)

  obj

}

set_value_js.GCheckbox <- function(obj, value) {
  ## get obj, setValue(true)
  tpl <- "
  {{{oid}}}.items.get(0).setValue({{{value}}});
"
  oid <- o_id(obj)
  value <- toJSON(value)

  push_queue(whisker.render(tpl))
}

