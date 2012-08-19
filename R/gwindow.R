##' @include gcontainer.R
##' @include icon.R
NULL

## TODO: parent -- subwindow, clean up on close

##' gwindow
##'
##' @export
gwindow <- function(title="", parent=NULL, ...,
                    renderTo=NULL,
                    width=NULL,
                    height=NULL,
                    ext.args=NULL
                    ) {

  if(!is.null(parent))
    return(gsubwindow(title, ..., width=width, height=height, ext.args=ext.args))
  
  obj <- new_item()
  class(obj) <- c("GWindow", "GContainer", "GComponent", class(obj))
  
  ## add to data base
  value <- title
  properties <- list(modal=FALSE)
  set_vals(obj, value=value, properties=properties)

  
  args <- list(
               layout="fit",
               renderTo=I("Ext.getBody()"),
               items=I(sprintf("[%s]", list_to_object(list(xtype="panel", id=as.character(obj), layout="fit")))),
               defaults=list(
                 autoScroll=TRUE,
                 autoHeight=TRUE,
                 autoWidth=TRUE
                 )
               )

  ## add some stock icons
  icon <- list.files(system.file("icons", package="gWidgetsWWW2.rapache"), full=TRUE)
  icon <- Filter(function(x) grepl("\\.png$",x), icon)
  nm <- gsub("\\.png$", "", basename(icon))
  icon_css <- addStockIcons(nm, icon)
  
  title <- shQuote(title)
  tpl <- '
var gWidget_toplevel = Ext.create({{{constructor}}}, {{{args}}});
var {{{oid}}} = gWidget_toplevel.child(0);
 {{#title}}document.title = {{{title}}};{{/title}}
 {{{icon_css}}}
'
  constructor <- shQuote("Ext.container.Viewport")
  args <- list_to_object(merge_list(args, ext.args))
  oid <- o_id(obj)
  push_queue(whisker.render(tpl))

  

  
  obj
}

## add for window captures "bars"
add.GWindow <- function(parent, child, ...) {

  if(is(child, "GStatusBar") || is(child, "GMenuBar") || is(child, "GToolBar")) {
    message("add a bar")
    oid <- o_id(parent)
    cid <- o_id(child)
    push_queue(whisker.render("{{oid}}.addDocked({{cid}});"))
  } else {
    NextMethod()
  }
}


"visible<-.GWindow" <- function(obj, value) {
  if(value)
    do_layout()
}


do_layout <- function() {
  push_queue("gWidget_toplevel.doLayout()")
}



gsubwindow <- function(title, ..., width, height, ext.args) {


  obj <- new_item()
  class(obj) <- c("GSubWindow", "GWindow", "GContainer", "GComponent", class(obj))
  
  ## add to data base

  width <- width %||% 200
  height <- height %||% 200
  constructor <- "Ext.window.Window"

  args <- list(renderTo=I("Ext.getBody()"),
               title=title,
               layout="fit",
               width=width,
               height=height,
               closeAction="hide",
               plain=TRUE,
               button=I(sprintf('[{text: "Close", handler: function(){%s.hide()}}]', o_id(obj)))
               )
  
  args <- merge_list(args, ext.args)
  push_queue(write_ext_constructor(obj, constructor, args))
  
  call_ext(obj, "show")
  
  obj
  
}

