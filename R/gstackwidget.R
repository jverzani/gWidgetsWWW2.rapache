##' @include gcontainer.R
NULL

##' stack widget is a "card" container. Use \code{gnotebook} methods
##' to change cards
##'
##' See ex-gstackwidget.R for an example
##' @inheritParams gwidget
##' @export
gstackwidget <- function(container, ...,
                         width=NULL, height=NULL, ext.args=NULL
                      ) {
  obj <- new_item()
  class(obj) <- c("GStackWidget", "GContainer", "GComponent", class(obj))

  properties <- list(children=c(), coerce.with="as.numeric")
  set_vals(obj,  value=0L, properties=properties)

  
  constructor <- "Ext.Panel"
  args <- list(layout="card",
               bodystype="padding:15px",
               width=width,
               height=height,
               defaults=list(border=FALSE)
               )
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))


  add(container, obj, ...)
  
  obj
}

## add page
add.GStackWidget <- function(obj, child, ...) {
  children <- get_properties(obj)$children
  children <- unique(c(children, child))
  update_property(obj, "children", children)

  set_value(obj, length(children))
  
  call_ext(obj, "add", list(
                            items=I(sprintf("[%s]", o_id(child)))
                            ))
  ## push to end
  tpl <- "
  {{{oid}}}.getLayout().setActiveItem({{page_no}});
"
  oid <- o_id(obj)
  page_no <- length(children) - 1
  push_queue(whisker.render(tpl))
}

## remove object
delete.GStackWidget <- function(obj, child, index) {
  children <- get_properties(obj)$children
  if(!missing(child)) {
    index <- match(child, children)
    if(is.na(index)) return()
  }

  children <- children[-index]
  update_property(obj, "children", children)

  if(index <= (cur <- svalue(obj)))
    set_value(obj, max(0, cur - 1))
  
  oid <- o_id(obj)
  index <- index-1

  
  tpl <- '
  {{{oid}}}.remove({{{oid}}}.getComponent({{index}}));
'

  push_queue(whisker.render(tpl))
}

## number of children
length.GStackWidget <- function(x) length(get_properties(x)$children)

## set tab number through svalue<-
set_value_js.GStackWidget <- function(obj, value) {

  oid <- o_id(obj)
  index <- value - 1
  
  tpl <- '
   {{oid}}.getLayout().setActiveItem({{index}})
'
   push_queue(whisker.render(tpl))
}
