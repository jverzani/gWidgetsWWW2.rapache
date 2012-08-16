##' @include gcomponent.R
NULL

##' gbutton
##'
##' @export

gbutton <- function(text, handler, action=NULL,  container,
                    ..., ext.args=list()
                    ) {

  if(is(action, "GAction"))
    return(gbutton_action(action, container))
  
  obj <- new_item()
  class(obj) <- c("GButton", "GWidget", "GComponent", class(obj))

  ## vals
  set_vals(obj, value=text)

  
  ## js
  constructor <- "Ext.Button"
  args <- list(text=as.character(text),
               iconCls=get_stock_icon_by_name(text)
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


set_value_js.GButton <- function(obj, value) {
  call_ext(obj, "setText", value)
  icon <- get_stock_icon_by_name(value)
  call_ext(obj, "setIconCls", icon)
}



## make a button from the action object
gbutton_action <- function(action, container, ...) {
  ## XXX define me
  obj <- new_item()
  class(obj) <- c("GButtonAction", "GWidget", "GComponent", class(obj))

  constructor <- "Ext.Button"
  args <- list()
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))
  

  add(container, obj)

  obj
}
