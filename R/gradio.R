##' @include gcomponent.R
NA

##' Radio button group
##'
##' A basic radio button group. Specify the labels through items. The main value is the label or index.
##' @param items Vector of items to choose one from.
##' @param selected index of initially selected item
##' @param horizontal logical. Horizontal or vertical layout. (See also columns)
##' @param columns Can be used to override horizontal TRUE or FALSE
##' @return a \code{GRadio} reference class object
##' @export
##' @note the \code{[<-} method (to change the labels) is not implemented.
gradio <- function(items,
                   selected = 1, horizontal=TRUE,
                   handler = NULL, action = NULL,
                   container = NULL, ...,
                   width=NULL, height=NULL, ext.args=NULL,
                   flex=1,              # NULL to turn off
                   columns=ifelse(horizontal,length(items), 1)) {

  obj <- new_item()
  class(obj) <- c("GRadio", "GWidget", "GComponent", class(obj))

  ## vals: value is item, not index
  set_vals(obj, value=items[selected], items=items)
  
  ## js
  constructor <- "Ext.form.RadioGroup"
  args <- list(items=I(.items_as_array(obj, items)),
               width = width,
               height = height,
               vertical=!horizontal,
               columns=columns,
               defaults=list(flex=flex)
               )
  
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  svalue(obj, index=TRUE) <- min(length(items), max(1, as.integer(selected)))
  
  ## add
  add(container, obj, ...)

  
  ## handlers
  addHandlerChanged(obj, handler=function(h, ...) {})
  if(!missing(handler)) 
    addHandlerChanged(obj, handler, action)

  obj
}

## call setValue on item
set_value_js.GRadio <- function(obj, value) {
  ## need to set, value is value
  idx <- match(value, get_items(obj))

  tpl <- '
 {{{oid}}}.items.get({{idx}} - 1).setValue(true);
'
  oid <- o_id(obj)
  push_queue(whisker.render(tpl))
}

## hacke figure this out.
"names<-.GRadio" <- function(x, value) {
  tpl <- "{{{oid}}}.getComponent({{idx}}).boxLabelEl.setHTML({{{label}}});"
  oid <- o_id(x)
  mapply(function(idx, label, oid) push_queue(whisker.render(tpl)),
         seq_along(value) - 1, shQuote(value), oid)

  x
}


## helper make array of item object
.items_as_array <- function(obj, items) {
  "Return items as array"
  
  l <- mapply(function(label, value, nm) list_to_object(list(boxLabel=label, inputValue=value, name=nm)),
              items, seq_along(items), sprintf("%s_radio", o_id(obj)),
              SIMPLIFY=FALSE)

  sprintf("[%s]", paste(l, collapse=","))
}

## handlers
before_handler.GRadio <- function(obj, signal, params, ...) {
  ## we pass back index, we store value
  items <- get_items(obj)
  idx <- as.integer(params$value)
  value <- items[idx]
  set_value(obj, items[idx])
}

addHandlerChanged.GRadio <- function(obj, handler, action=NULL, ...) {
  addHandlerChange(obj, handler, action, ...)
}


addHandlerChange.GRadio <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "change", handler, action, ...,
             params=sprintf("var params={value:newValue.valueOf().%s_radio};", o_id(obj)) ## pass back index in value
             )
}

## alias
addHandlerClicked.GRadio <- addHandlerChanged.GRadio
