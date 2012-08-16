##' @include gcomponent.R
NULL

##' glabel
##'
##' @export

glabel <- function(text, container,
                    ..., ext.args=list()
                    ) {
  obj <- new_item()
  class(obj) <- c("GLabel", "GWidget", "GComponent", class(obj))

  ## vals
  set_vals(obj, value=text)

  
  ## js
  constructor <- "Ext.form.Label"
  args <- list(html=as.character(text))
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  ## add
  add(container, obj, ...)

  ## no handler
  obj
}


## methods
set_value_js.GLabel <- function(obj, value) {
  call_ext(obj, "setText", value)
}
