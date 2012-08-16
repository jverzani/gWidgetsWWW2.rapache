##' @include gcontainer.R
NULL

##' gformlayout
##'
##' @export
gformlayout <- function(
                        align=c("default", "left", "center", "right", "top"),
                        spacing=5,
                        container = NULL, ...,
                        label.width=100,
                        width=NULL, height=NULL, ext.args=NULL){

  obj <- new_item()
  class(obj) <- c("GFormLayout", "GContainer", "GComponent", class(obj))


  properties <- list(stub=FALSE)
  set_vals(obj,  properties=properties)

  constructor <- "Ext.form.Panel"
  args <- list(bodyPadding=as.integer(spacing),
               border=FALSE,
               labelSeparator="",
               labelAlign=c(
                 "default"="left",
                 "left"="left",
                 "center"="center",
                 "right"="right",
                 "top"="top")[match.arg(align)],
               defaults=list(
                 labelWidth=label.width
                 )
               )
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))
#  size(obj) <- list(width=width, height=height)
  

  add(container, obj, ...)
  
  obj
}

