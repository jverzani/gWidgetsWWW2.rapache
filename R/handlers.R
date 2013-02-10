
## Add a handler for a signal
add_handler <- function(obj, signal, handler, action=NULL, ...) {

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
  
  key <- as.character(obj)

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
  handlers$all_blocked <- Filter(function(x) !identical(x,as.integer(obj)), handlers$all_blocked)
  ..e..$..handlers.. <- handlers
}

## really dangerous thing to do, as it removes transport values too!
remove_handlers <- function(obj) {
  stop("Really a bad idea for us. Just block them instead.")
#  handlers <- ..e..$..handlers..
#  handlers[[as.character(obj)]] <- NULL
#  ..e..$..handlers.. <- handlers
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

##' bind a handler to an object for a given signal
##'
##' @param obj object that emits signal
##' @param signal signal name
##' @param handler handler. A function with first argument which receives a list.
##' @param action object to pass to function call to parameterize it
##' @param ... passed along
##' @param fn_args argument of javascript function
##' @param params Used internally
##' @return a handler ID
addHandler <- function(obj, signal, handler, action=NULL, ..., fn_args=callback_args(signal), params=NULL) UseMethod("addHandler")

addHandler.default <- function(obj, signal, handler, action=NULL,
                               ...,
                               fn_args=callback_args(signal),
                               params=NULL, ## "var params=...;"
                               buffer=100   # ms buffer for repeated calls
                               ) {

  n <- add_handler(obj, signal, handler, action) # stores handler
  if(n > 1) return() ## only write JS once

  ## add JS code
  url <- make_url("ajax_call") ##"/custom/gw/ajax_call"

  ## put in buffer but don't know that it works
    tpl <- '
 {{oid}}.on("{{signal}}", function({{{fn_args}}}) {
  {{#params}}{{{params}}};{{/params}}
  Ext.Ajax.request({
    url:"{{{url}}}",
    params:{ID:ID,obj:"{{obj}}", signal:"{{signal}}" {{#params}},params:JSON.stringify(params){{/params}} },
    success:eval_response
  });
}, {{{oid}}}, {delay:5, buffer:{{buffer}} });
'
  oid <- o_id(obj)
  push_queue(whisker.render(tpl))
}

## our handler interface

## changed

##' Name given to most common action (widget changed state, ...)
##'
##' @export
##' @rdname gWidgetsWWW2-handlers
addHandlerChanged <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerChanged")

##' Default S3 method
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerChanged default
##' @S3method addHandlerChanged default
addHandlerChanged.default <- function(obj, handler, action=NULL, ...) {
  addHandlerClicked(obj, handler, action, ...)
}

## click handler
##' Handler for a click event
##'
##' @export
##' @rdname gWidgetsWWW2-handlers
addHandlerClicked <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerClicked")

##' Default S3 method
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerClicked default
##' @S3method addHandlerClicked default
addHandlerClicked.default <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "click", handler, action, ...)
}


## click handler
##' Handler for a double click event
##'
##' @export
##' @rdname gWidgetsWWW2-handlers
addHandlerDoubleclick <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerDoubleclick")


##' Default S3 method
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerDoubleclick default
##' @S3method addHandlerDoubleclick default
addHandlerDoubleclick.default <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "dblclick", handler, action, ...)
}

## enter
##' Handler for the enter key event?
##'
##' @export
##' @rdname gWidgetsWWW2-handlers
addHandlerEnter <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerEnter")

##' Default S3 method
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerEnter default
##' @S3method addHandlerEnter default
addHandlerEnter.default <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "enter", handler, action, ...)
}


## blur handler
##' handler for loss of keyboard focus event
##'
##' @export
##' @rdname gWidgetsWWW2-handlers
addHandlerBlur <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerBlur")

##' Default S3 method
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerBlur default
##' @S3method addHandlerBlur default
addHandlerBlur.default <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "blur", handler, action, ...)
}



## select handler
##' handler for select event
##'
##' @export
##' @rdname gWidgetsWWW2-handlers
addHandlerSelect <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerSelect")

##' Default S3 method
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerSelect default
##' @S3method addHandlerSelect default
addHandlerSelect.default <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "select", handler, action, ...)
}



## Change handler
##' handler for change of state event
##'
##' @export
##' @rdname gWidgetsWWW2-handlers
addHandlerChange <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerChange")

##' Default S3 method
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerChange default
##' @S3method addHandlerChange default
addHandlerChange.default <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "Change", handler, action, ...)
}



##' handler for mouse down event
##'
##' @export
##' @rdname gWidgetsWWW2-handlers
addHandlerMouseDown <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerMouseDown")

##' Default S3 method
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerMouseDown default
##' @S3method addHandlerMouseDown default
addHandlerMouseDown.default <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "mousedown", handler, action, ...)
}

##' handler for mouse up event
##'
##' @export
##' @rdname gWidgetsWWW2-handlers
addHandlerMouseUp <- function(obj, handler, action=NULL, ...) UseMethod("addHandlerMouseUp")

##' Default S3 method
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerMouseUp default
##' @S3method addHandlerMouseUp default
addHandlerMouseUp.default <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "mouseup", handler, action, ...)
}
