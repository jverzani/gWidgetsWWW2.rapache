##' @include gcomponent.R
NULL

## XXX test, recurse, popup, ...

##' Menubar implementation
##'
##' A menubar for gwindow instances. Menu items are specified with a
##' named list. The heirarchical nature of the list maps to the
##' heirarchical menu structure, with the names giving the menu
##' names. The menu actions are specified using \code{gaction}
##' elements. These may also be \code{gseperator()} instances.
##' 
##' Menubars should only be added to \code{gwindow} instances, but
##' this is not strictly enforced, any \code{Ext.Panel}-based
##' container would do.
##'
##' Menubars can take checkboxes and radio buttons. Specify them without
##' a parent container.
##' @param menulist list of actions. Actions must have parent specified
##' @param popup Logical. ignored for now
##' @inheritParams gwidget
##' @return an ExtWidget object
##' @export
##' @examples
##' w <- gwindow()
##' sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
##' stub = function(...) galert("stub", parent=w)
##' l <- list(
##' File = list(open=gaction("Open", handler=stub, parent=w),
##'             new = gaction("New", handler=stub, parent=w),
##'             gseparator(),
##'             quit = gaction("Quit", handler=stub, parent=w)),
##' Edit = list(save = gaction("Save", handler=stub, parent=w),
##'             gcheckbox("some state", checked=TRUE, handler=stub)
##'             )
##' )
##' m <- gmenu(l, cont=w)
##' gtext("Text goes here", cont=w)
gmenu <- function(menulist,
                  popup = FALSE,
                  action=NULL,
                  container = NULL,..., ext.args=NULL) {

   
  obj <- new_item()
  class(obj) <- c("GMenuBar", "GWidget", "GComponent", class(obj))
  if(popup) ## popup is different
    class(obj) <- c("GPopupMenu", class(obj))

  


  ## vals
  set_vals(obj, properties=list(popup=popup))

  
  ## js
  constructor <- "Ext.toolbar.Toolbar"
  args <- list(dock="top"
               )
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  ## This is an issue!
  ## list is either named -> menus or not -- toolbar
  make_menu(obj, menulist)


  
#  add_to_toolbar(obj, menulist)
  
  ## add
  add(container, obj, ...)

}

make_menu <- function(obj, menulist) {
  nms <- names(menulist)
  if(is.null(nms)) {
    sapply(menulist, add_to_toolbar, obj=obj, nm="")
  } else {
    mapply(function(nm, item) add_to_toolbar(item, obj=obj, nm=nm),
           nms, menulist)
  }
}

gmenu_item <- function(x, nm) {
   
  obj <- new_item()
  class(obj) <- c("GMenuItem", "GWidget", "GComponent", class(obj))

  constructor <- "Ext.menu.Menu"
  args <- list(floating=TRUE,
               plain=TRUE
               )
  

  push_queue(write_ext_constructor(obj, constructor, args))

  
#  add_to_toolbar(x, obj, "")
#  add_menu_items(obj, x)

  obj
}

add_menu_items <- function(obj, x) {
  nms <- names(x)
  has_names <- !is.null(nms)

  lapply(x, function(item) {
    if(is(item, "list")) {
      ## recurse
      ## XXX??? 
    } else if(is(item, "GAction")) {
      call_ext(obj, "add", o_id(item))
    } else if(is(item, "GSeparator")) {
      call_ext(obj, "add", "'-'")
    } else {
      call_ext(obj, "add", o_id(item))
    }
    
  })
}
       
  

add_to_toolbar <- function(x, obj, nm="") UseMethod("add_to_toolbar")
add_to_toolbar <- function(x, obj, nm="") {
  if(is.list(x)) {
    menu <- gmenu_item(x, nm)
    tpl <- "
  {{{oid}}}.add({text:'{{{nm}}}', menu:{{{mid}}} });
"
    oid <- o_id(obj); mid <- o_id(menu)
    push_queue(whisker.render(tpl))
    sapply(x, add_to_toolbar, obj=menu)
  } else if(is(x, "GComponent")) {
    call_ext(obj, "add", o_id(x))
  } else if(is(x, "GAction")) {
    call_ext(obj, "add", o_id(x))
  } else if(is(x, "GSeparator")) {
    call_ext(obj, "add", "'-'")
  } else {
    message("No method for this toolbar type")
  }
}
  
