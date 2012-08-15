##' @include gcomponent.R
##' 
NULL

##' ggroup
##'
##' @export

ggroup <- function(horizontal=FALSE, spacing=3,
                   use.scrollwindow=FALSE,
                   container=NULL, ...,
                   width=NULL, height=NULL, ext.args=list()
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
  
  args <- list(border=TRUE,
               hideBorders=TRUE,
               defaults=list(
                 margins=sprintf("%s %s %s %s", margins[1], margins[2], margins[3], margins[4])
                 ),
               autoScroll=use.scrollwindow
               )
  args$layout <- if(horizontal) list(type="hbox", align="stretch") else list(type="vbox", align="stretch")
  
  args <- merge_list(args, ext.args, add_dots(...))
  push_queue(write_ext_constructor(obj, constructor, args))
  

  add(container, obj, ...)
  
  obj
}


gvbox <- function(container=NULL, ...,
                  width=NULL, height=NULL, ext.args=list())
  ggroup(horizontal=FALSE, container=container, ...,
         width=width, height=height, ext.args=ext.args)
