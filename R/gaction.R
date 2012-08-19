##' @include gcomponent.R
NULL

##' gaction implementation
##'
##' actions are reusable encapsulations of actions. The
##' \code{svalue<-} method can be used to update the text associated
##' with an action. Use \code{enabled<-} to adjust sensitivity to
##' mouse events. The \code{visible<-} method can adjust if objects
##' proxying the action are visible. The \code{set_icon} reference
##' class method can be used to set the icon (no S3 method)
##'
##' See the method \code{add_keybinding} to add a simple keybinding to
##' initiate this action.
##' @param label Text for action
##' @param tooltip tooltip. Ignored for this toolkit
##' @param icon action icon class
##' @param key.accel keyboard accelerator. Single key, e.g. "X",
##' "LEFT" (arrow), "PAGE_UP", "Ctrl-n", "Alt-X". Use "Shift" to force
##' that. List of key events is given here:
##' \code{http://docs.sencha.com/ext-js/4-1/#!/api/Ext.EventObject}.
##' @param handler function called when action is invoked
##' @param ... ignored
##' @return a \code{GWidget} object
##' @export
##' @examples
##' w <- gwindow()
##' a <- gaction("some action", handler=function(h,...) galert("asdf", parent=w), parent=w)
##' b <- gbutton(action=a, cont=w)
##' enabled(a) <- FALSE
##' svalue(a) <- "new text"
##' #
gaction <- function(label, tooltip=NULL, icon=NULL, key.accel=NULL,
                    handler, action=NULL,  ..., ext.args=list()) {

  
  obj <- new_item()
  class(obj) <- c("GAction", "GWidget", "GComponent", class(obj))

  ## vals
  set_vals(obj, value=label,
           properties=list(visible=TRUE, enabled=TRUE)
           )

   ## js
  tpl <- "function() {Ext.Ajax.request({
    url:'{{{url}}}',
    params:{ID:ID,obj:'{{obj}}',signal:'action', params:{}},
    success:eval_response
  })
}"
  url <- "/custom/gw/ajax_call"
  
  constructor <- "Ext.Action"
  args <- list(text=label,
               tooltip=tooltip,
               handler=I(whisker.render(tpl)),
               iconCls=get_stock_icon_by_name(icon)
               )
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))


  if(!is.null(key.accel))
    add_keybinding(obj, key.accel)
  

  ## handlers
  if(!missing(handler)) 
    addHandlerChanged(obj, handler, action)

  obj
}

##' use action as signal
addHandlerChanged.GAction <- function(obj, handler, action=NULL, ...) {
  ## don't use addHandler, but add_handler. We write handler code above in constructor
  add_handler(obj, "action", handler, action, ...)
}

##' Add keybinding to document for this action. Key is value for
##' Ext.EventObject:
##' http://docs.sencha.com/ext-js/4-1/#!/api/Ext.EventObject. Use
##' Ctrl-X, Alt-X of Shift-X indicate keys
add_keybinding <- function(obj, key.accel) {
  url <- "/custom/gw/ajax_call"
  
                           tpl <- "
var map = new Ext.util.KeyMap(document, {
    key: Ext.EventObject.{{key}},
    handler: function() {Ext.Ajax.request({
      url:'{{{url}}}',
      params:{ID:ID,obj:'{{obj}}',signal:'action', params:{}},
      success:eval_response
    })},
    shift: {{shift}},
    control: {{control}},
    alt: {{alt}}
});
"
  out <- whisker.render(tpl,
                        list(obj=as.numeric(obj),
                             url=url,
                             shift=ifelse(grepl("Shift", key), "true", "false"),
                             control=ifelse(grepl("Ctrl", key), "true", "false"),
                             alt=ifelse(grepl("Alt", key), "true", "false"),
                             key=toupper(tail(strsplit(key,"-")[[1]], n=1))
                             ))

  push_queue(out)
  
}

set_value_js.GAction <- function(obj, value) {
  call_ext(obj, "setText", value)
}

visible.GAction <- function(obj) get_properties(obj)$visible

"visible<-.GAction" <- function(obj, value) {
  update_property(obj, "visible", value)
  call_ext(obj, "setHidden", if(value) "false" else "true")
}


enabled.GAction <- function(obj) get_properties(obj)$enabled

"enabled<-.GAction" <- function(obj, value) {
  update_property(obj, "enabled", value)
  call_ext(obj, "setDisabled", if(value) "false" else "true")
}
