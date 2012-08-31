
## Add a handler for a signal
add_handler <- function(obj, signal, handler, action=NULL, ...) {

  message("add_handler")
  handlers <- ..e..$..handlers..
  
  key <- as.character(obj)
  if(is.null(handlers[[key]]))
    handlers[[key]] <- list()
  
  id <- handlers$id <- handlers$id + 1L

  ## get/update/store
  l <- handlers[[key]][[signal]] %||% list()
  l[[length(l) + 1]] <- list(handler=handler, action=action, obj=obj, id=id)
  handlers[[key]][[signal]] <- l

  ..e..$..handlers.. <- handlers

  ## we return length of l. If more than 1 we might not want to add js to call handler
  length(l)
  
}

## how to call the handler
## XXX Sometimes this calls handlers twice
call_handler <- function(obj, signal, params=list(), ...) {
  message("call handler")
  
  key <- as.character(obj)
  message("key:", key)
  handlers <- ..handlers.. #get("..handlers..", envir=topenv())
  blocked <- handlers$blocked
  if(obj %in% handlers$all_blocked)
    return()                            # all blocked
    
  if(is.null(handlers[[key]]))
    stop("No handlers for this object")

  if(is.null(handlers[[key]][[signal]]))
    stop(sprintf("No handler for this signal %s", signal))
  
  l <- handlers[[key]][[signal]]

  lapply(l, function(comp) {
    h <- merge_list(list(obj = comp$obj, action=comp$action), params)
    if(!comp$id %in% blocked) {
      before_handler(comp$obj, signal, params)
      comp$handler(h, ...)
    }
  })
  
}

## S3 method call prior to handler call
before_handler <- function(obj, signal, params, ...) UseMethod("before_handler")
before_handler.default <- function(obj, signal, params, ...) {
  if(!missing(params) && !is.null(params$value))
    set_value(obj, params$value)
}


## block a handler. Handler_id may be a list (eg, expandgroup)
block_handler <- function(obj, handler_id) {
  handlers <- ..e..$..handlers..
  handlers$blocked <- unique(c(handlers$blocked, unlist(handler_id)))
  ..e..$..handlers.. <- handlers
}

unblock_handler <- function(obj, handler_id) {
  handlers <- ..e..$..handlers..
  handlers$blocked <- Filter( function(x) ! x %in% unlist(handler_id), handlers$blocked)
  ..e..$..handlers.. <- handlers
}

## block handlers
block_handlers <- function(obj) {
  handlers <- ..e..$..handlers..
  handlers$all_blocked <- unique(c(obj, handlers$all_blocked))
  ..e..$..handlers.. <- handlers
}

unblock_handlers <- function(obj) {
  handlers <- ..e..$..handlers..
  handlers$all_blocked <- Filter(function(x) !identical(x,obj), handlers$all_blocked)
  ..e..$..handlers.. <- handlers
}

callback_args <- function(signal) {
  switch(signal,
         afteredit = "e",                 # for gdf cell editing
         beforechange="tb, params",       # for paging toolbar
         blur="w",                        # w = "this"
         bodyresize = "w, width, height",
         bodyscroll = "scrollLeft, scrollRight",
         cellcontextmenu = "w, rowIndex, cellIndex, e",
         cellclick = "w, td, cellIndex, rec, tr, rowIndex, e, opts", # grid
         celldblclick = "w, td, cellIndex, rec, tr, rowIndex, e, opts", # grid
         change="w, newValue, oldValue, eOpts",
         changecomplete="w, newValue, thumb, eOpts",
         beforechange = "w, newValue, oldValue",
         check = "w, checked",
         click = "w, e", # gtree?
         collapse = "w",                  # combobox
         columnmove = "oldIndex, newIndex",
         columnresize = "columnIndex, newSize",
         dblclick = "e",                  # grid -- not celldblclick
         destroy="w", beforedestroy = "w",
         destroyed = "w, c", # child component destroyed
         disable="w",
         drag = "w, e", dragend = "w,e", dragstart = "w,e",
         enable = "w",
         expand = "w",                    # combobox
         fileselected = "w, s",               # FileUploadField
         focus = "w",
         headerclick = "w, columnIndex, e", # grid
         headercontextmenu = "w, columnIndex, e", # grid
         headerdblclick = "w, columnIndex, e", # grid
         headermousedown = "w, columnIndex, e", # grid       
         hide = "w", beforehide = "w",
         invalid = "w",
         itemclick="view, rec, item, index, event, opts",
         itemdblclick="view, rec, item, index, event, opts",
         keydown = "w,e",                 # e Ext.EventObject
         keypress = "w,e",
         keyup = "w,e",
         mousedown = "e",
         mouseover = "e", 
         mousemove = "e", 
         move = "w, x, y",
         render = "w", beforerender = "w",
         resize = "w, adjWidth, adjHeight, rawWidth, rawHeight",
         rowclick = "w, rowIndex, e", # grid
         rowcontextmenu = "w, rowIndex, e", # grid
         rowdblclick = "w, rowIndex, e", # grid
         rowmousedown = "w, rowIndex, e", # grid       
         select = "selModel,record,index,opts",
         beforeselect = "selModel, record, index",
         selectionchange = "selModel, selected, opts",    # gcheckboxgrouptable, gtable
         show = "w", beforeshow = "w", 
         specialkey = "w, e",
         tabchange = "w, tab", # notebook
         toggle = "w, value",             # gtogglebutton
         valid = "w",
         "")
}     
## public interface
addHandler <- function(obj, signal, handler, action=NULL, ..., fn_args=callback_args(signal), params=NULL) UseMethod("addHandler")

addHandler.default <- function(obj, signal, handler, action=NULL,
                               ...,
                               fn_args=callback_args(signal),
                               params=NULL ## "var params=...;"
                               ) {
  message("addHandler")
  n <- add_handler(obj, signal, handler, action) # stores handler
  if(n > 1) return()

  ## add JS code
  url <- make_url("ajax_call") ##"/custom/gw/ajax_call"
  
    tpl <- '
ogWidget_{{obj}}.on("{{signal}}", function({{{fn_args}}}) {
  {{#params}}{{{params}}};{{/params}}
  Ext.Ajax.request({
    url:"{{{url}}}",
    params:{ID:ID,obj:"{{obj}}", signal:"{{signal}}" {{#params}},params:JSON.stringify(params){{/params}} },
    success:eval_response
  });
});
'
  push_queue(whisker.render(tpl))
}

## our handler interface

## changed
addHandlerChanged <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerChanged")
addHandlerChanged.default <- function(obj, handler, action=NULL, ...) {
  message("Changed handler")
  addHandlerClicked(obj, handler, action, ...)
}

## click handler
addHandlerClicked <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerClicked")

addHandlerClicked.default <- function(obj, handler, action=NULL, ...) {
  message("click handler")
  addHandler(obj, "click", handler, action, ...)
}


## click handler
addHandlerDoubleclick <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerDoubleclick")

addHandlerDoubleclick.default <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "dblclick", handler, action, ...)
}

## enter
addHandlerEnter <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerEnter")

addHandlerEnter.default <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "enter", handler, action, ...)
}


## blur handler
addHandlerBlur <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerBlur")

addHandlerBlur.default <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "blur", handler, action, ...)
}



## select handler
addHandlerSelect <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerSelect")

addHandlerSelect.default <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "select", handler, action, ...)
}



## Change handler
addHandlerChange <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerChange")

addHandlerChange.default <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "Change", handler, action, ...)
}
