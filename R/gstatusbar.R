##' @include gcontainer.R
NULL

##' Status bar for gwindow instances
##'
##' Status for main window. Use \code{gwindow} instance for parent
##' container. The \code{svalue<-} method can be used to change the
##' value.
##' @param text text for label
gstatusbar <- function(text = "", container=NULL, ..., ext.args=NULL) {
  if(!is(container, "GWindow") || is(container, "GGroup"))
    stop("Container must be window or box container")


  obj <- new_item()
  class(obj) <- c("GStatusBar", "GContainer", "GComponent", class(obj))

  constructor <- "Ext.toolbar.Toolbar"

  txt <- shQuote(text)
  tpl <- "
 [{xtype:'label', text:''},
  {xtype:'label', text:{{{txt}}} }
 ]
"

  args <- list(dock='bottom',
               items=I(whisker.render(tpl))
               )

  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  add(container, obj, ...)
  
  obj
}


set_value_js.GStatusBar <- function(obj, value) {
  tpl <- "
  {{{oid}}}.getComponent(1).setText({{{value}}}); {{{oid}}}.doLayout();
"
  oid <- o_id(obj)
  value <- shQuote(value)
  push_queue(whisker.render(tpl))
}

## show/hide loading image
statusbar_loading <- function(obj, show=TRUE, msg="'loading... (replace with spinner)'") {
  txt <- ifelse(show,
                msg ,
                "''")
  iconCls <- ifelse(show,
                    "iconCls:'x-status-busy'",
                    NULL)
  oid <- o_id(obj)
  tpl <- '
 {{{oid}}}.getComponent(0).setStatus({text:{{{txt}}}{{iconCls}} }); {{{oid}}}.doLayout();
'
  push_queue(whisker.render(tpl))
}
  
