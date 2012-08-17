##' @include gcontainer.R
NULL

##' A "border" layout is a 5-panel layout where  satellite panels
##' surround a "center" panel. 
##'
##' The \code{gborderlayout} container implements a border layout
##' where 4 panels surround a main center panel. The panels may be
##' configured with a title (like \code{gframe}) and may be
##' collapsible (like \code{gexpandgroup}). Both configurations are
##' done at construction time. The panels only hold one child, so one
##' would add a container to have more complicated layouts.
##'
##' To add a child component, one specifies a value of \code{where} to
##' the \code{add} method (implicitly called by the constructor, so in
##' practice this argument is passed through \code{...} by the
##' constructor). The value of \code{where} is one of
##' \code{c("center","north", "south", "east", "west")}. Child
##' components are added with the "fit" layout, which is basically the
##' same as specifying \code{expand=TRUE} and \code{fill=TRUE}, though those
##' arguments are ignored here.
##' 
##' The satellite panels may be resized through the reference class
##' method \code{set_panel_size} with arguments \code{where} and a
##' numeric \code{dimension}. 
##' @inheritParams gwidget
##' @param title a list  with named components from
##' \code{c("center","north", "south", "east", "west")} allowing one
##' to specify titles (as length-1 character vectors) of the
##' regions. The default is no title. A title may be added later by
##' adding a \code{gframe} instance, but that won't work well with a
##' collapsible panel.
##' @param collapsible a list with  named components from
##' \code{c("center","north", "south", "east", "west")} allowing one
##' to specify through a logical if the panel will be collapsible,
##' similar to \code{gexpandgroup}. The default is \code{FALSE}
##' @return a \code{GBorderLayout} reference class object
##' @seealso \code{\link{gpanedgroup}} is a two-panel border layout
##' with just an "east" or "south" satellite panel configured.
##' @note \code{gpanedgroup} does not sit nicely within a
##' \code{gnotebook} container, avoid trying this.
##' @author john verzani
##' @export
gborderlayout <- function(container,
                          ...,
                          width="100%",
                          height="100%",
                          ext.args=NULL,
                          title=list(),
                          collapsible=list()
                          ) {
  obj <- new_item()
  class(obj) <- c("GBorderLayout", "GContainer", "GComponent", class(obj))


  properties <- list()
  set_vals(obj,  properties=properties)

  constructor <- "Ext.panel.Panel"
 
  args <- list(width=width,
               height=height,
               layout="border",
               items=I(sprintf("[%s]", make_panels(obj, title, collapsible)))
               )
  


  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))
  

  add(container, obj, ...)
  
  obj
}

make_panels <- function(obj, title=list(), collapsible=list()) {
  where <- c("center","north", "south", "east", "west")
  out <- lapply(where, function(i) {
    lst <- list(region=i,
                xtype="panel",
                layout="fit",
                title=title[[i]],
                collapsible=collapsible[[i]],
                split=TRUE,
                margins="0,5,5,5",
                id=region_id(obj, i)
                )
    list_to_object(lst)
  })
  paste(out, collapse=",")
}

region_id <- function(obj,
                      where=c("center","north", "south", "east", "west")) {
  "Return ID of region"
  sprintf("%s_%s_region", o_id(obj), match.arg(where))
}

add.GBorderLayout <- function(parent, child,
                              where=c("center","north", "south", "east", "west"),
                              ...) {
  where <- match.arg(where)

  
   tpl <- "
wrc = Ext.getCmp('{{region_id}}');
wrc.removeAll();
wrc.add({{child_id}});
"
  region_id <- region_id(parent, where)
  child_id <- o_id(child)

  push_queue(whisker.render(tpl))
}

##' set theh panel size
##'
##' @param  where which panel (center, north, ...),
##' @param dimension width or height as appropriate
set_panel_size <- function(obj, where=c("center","north", "south", "east", "west"),
                           dimension) {
  
  ## XXX What to do with center?
  where <- match.arg(where)
  meth <- ifelse(where %in% c("east", "west"), "setWidth", "setHeight")

                                tpl <- "
wrc = Ext.getCmp('{{region_id}}');
wrc.{{meth}}({{dimension}});
"
   region_id <- region_id(obj, where)
   push_queue(whisker.render(tpl))
  
}

##' collapse or expand (collapse=FALSE) collapsible panel
set_panel_collapse <- function(obj,
                               where=c("center","north", "south", "east", "west"),
                               collapse=TRUE) {
   
  where <- match.arg(where)
  meth <- ifelse(collapse, "collapse", "expand")
                                
  tpl <- "
wrc = Ext.getCmp('{{region_id}}');
wrc.{{meth}}();
"
  region_id <- region_id(obj, where)
  push_queue(whisker.render(tpl))
}
