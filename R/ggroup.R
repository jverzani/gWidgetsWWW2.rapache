##' @include gcontainer.R
##' 
NULL

## Box containers: ggroup, gvbox, gframe, gexpandgroup


##' The basic box container
##'
##'
##' Packing is from left to right
##' (horizontal) or top to bottom (gvbox)
##'
##' @export
ggroup <- function(horizontal=TRUE,
                   spacing=2,           # between widget
                   body.padding=2,       # external
                   use.scrollwindow=FALSE,
                   container=NULL, ...,
                   width=NULL, height=NULL, ext.args=list(),
                   align="stretch",   # do "stretch", fill orthogonally
                   text=NULL, collapsible=FALSE #
                   ) {
  obj <- new_item()
  class(obj) <- c("GGroup", "GContainer", "GComponent", class(obj))


  properties <- list(horizontal=horizontal)
  set_vals(obj,  properties=properties)

  constructor <- "Ext.panel.Panel"
  ## spacing
  margins <- spacing
  if(length(spacing) == 1)
    margins <- rep(spacing, 4)
  else if(length(spacing) == 2)
    margins <- rep(spacing, 2)
  else if(length(spacing) == 3)
    margins <- c(spacing, spacing[2])
  else
    margins <- spacing[1:4]
  spacing <<- margins
  
  args <- list(border=FALSE,
               hideBorders=TRUE,
               bodyPadding=body.padding,
               defaults=list(
                 margins=sprintf("%s %s %s %s", margins[1], margins[2], margins[3], margins[4])
                 ),
               autoScroll=use.scrollwindow,
               preventBodyReset=TRUE,
               title=text,
               collapsible=collapsible
               )
  layout_args <- list(type=ifelse(horizontal, "hbox", "vbox"))

  ## align: stretch gives RGtk2 like behaviour: widgets fill in direction
  ## orthogonal to packing
  ## From HBox.js:
  ## * - **stretch** : child items are stretched vertically to fill the height of the container
  ## * - **stretchmax** : child items are stretched vertically to the height of the largest item. 
  if(!is.null(align))
    layout_args$align <- align
  args$layout <- layout_args
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))
  

  add(container, obj, ...)
  
  obj
}


## add for window captures "bars"
add.GGroup <- function(parent, child, ...) {
  if(is(child, "GStatusBar") || is(child, "GMenuBar") || is(child, "GToolBar")) {
    message("add a bar")
    oid <- o_id(parent)
    cid <- o_id(child)
    push_queue(whisker.render("{{oid}}.addDocked({{cid}});"))
  } else {
    NextMethod()
  }
}


## easier to type than horizontal=FALSE
gvbox <- function(container=NULL, ..., use.scrollwindow=TRUE,
                  width=NULL, height=NULL, ext.args=list())
  ggroup(horizontal=FALSE, container=container, ...,
         use.scrollwindow=use.scrollwindow,
         width=width, height=height, ext.args=ext.args)


addSpring <- function(obj) {
  glabel("&nbsp;", container=obj, expand=100)
}

##' Framed box container
##'
##' Use \code{svalue<-} to adjust title
##' @export
gframe <- function(text = "", horizontal=TRUE,
                   spacing=2, body.padding=2,
                   use.scrollwindow=FALSE,
                   container=NULL, ...,
                   width=NULL, height=NULL, ext.args=list()) {

  obj <- ggroup(horizontal=horizontal,
                spacing=spacing,
                body.padding=body.padding,
                use.scrollwindow=use.scrollwindow,
                container=container,
                ...,
                width=width,
                height=height,
                ext.args=ext.args,
                text=text)
  class(obj) <- c("GFrame", class(obj))

  set_properties(obj, list(text=text))

  obj
}

svalue.GFrame <- function(obj, ...) get_properties(obj)$text

"svalue<-.GFrame" <- function(obj, ..., value) {
  value <-  as.character(value)
  props <- get_properties(obj)
  props$text <- value
  set_properties(obj, props)
  
  call_ext(obj, "setTitle", value)
  obj
}

##' expandable box container
##'
##' Use \code{visible<-} to toggle collapsed or expanded
##' programatically. Opens in a visible mode.  Use
##' \code{addHandlerChanged} to add a callback for when the widget
##' expands or collapses
##' @export
gexpandgroup <- function(text = "", horizontal = TRUE,
                         spacing=2, body.padding=2,
                         use.scrollwindow=FALSE,
                         container=NULL,
                         handler = NULL, action=NULL,
                         ...,
                         width=NULL,
                         height=NULL,
                         ext.args=NULL
                         ) {

  obj <- ggroup(horizontal=horizontal,
                spacing=spacing, body.padding=body.padding,
                use.scrollwindow=use.scrollwindow,
                container=container,
                ...,
                width=width,
                height=height,
                ext.args=ext.args,
                text=text,
                collapsible=TRUE)
  
  class(obj) <- c("GExpandGroup", "GFrame", class(obj))

  set_properties(obj, list(text=text, visible=TRUE))

  obj
}


## is group expanded?
visible.GExpandGroup <- function(obj) {
  get_properties(obj)$visible
}

"visible<-.GExpandGroup" <- function(obj, value) {
  update_property(obj, "visible", value)
  call_ext(obj, ifelse(value, "expand", "collapse"))

  obj
}


addHandlerChanged.GExpandGroup <- function(obj, handler, action, ...) {
  lapply(c("expand", "collapse"), addHandler, obj=obj, handler=handler, action=action)
}
