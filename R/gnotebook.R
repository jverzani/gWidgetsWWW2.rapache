##' @include gcontainer.R
NULL

##' Notebook container
##'
##' @param tab.pos where to place tabs. A value of 1 is the bottom, else the top.
##' @param close.buttons Logical. Are there close buttons on the tabs?
##' If \code{TRUE}, then the underlying methods (\code{length},
##' \code{svalue}, ...) will get all messed up!
##' @seealso The \code{\link{gstackwidget}} container is similar, but
##' has no tabs.
##' @export
##' @examples
##' w <- gwindow()
##' nb <- gnotebook(cont=w)
##' gbutton("hello", container=nb, label="My label") ## pass in label argument through ... to \code{add}
##' gbutton("page 2", container=nb, label="page 2")
##' svalue(nb) <- 1
gnotebook <- function(tab.pos = 3, close.buttons = FALSE, container, ...,
                      width=NULL, height=NULL, ext.args=NULL
                      ) {
  obj <- new_item()
  class(obj) <- c("GNotebook", "GContainer", "GComponent", class(obj))


  properties <- list(closable=as.logical(close.buttons),
                     children=c(),
                     coerce.with="as.numeric")
  set_vals(obj,  value=0, properties=properties)

  constructor <- "Ext.tab.Panel"
  args <- list(tabPosition = ifelse(tab.pos==1, "bottom", "top"),
                                              frame = TRUE,
                                              activeTab = 0,
                                              enableTabScroll = TRUE,
                                              defaults=list(autoScroll=TRUE),
                                              width=width,
                                              height=height
               )
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  ## push back active tab
  transport <- function(...) {}
  addHandlerChanged(obj, transport)

  add(container, obj, ...)
  
  obj
}

## as of now we don't store children, so no length or names method

## add page
add.GNotebook <- function(obj, child, label="Tab", tooltip=NULL, ...) {
  children <- get_properties(obj)$children
  children <- unique(c(children, child))
  update_property(obj, "children", children)
  
  set_value(obj, length(children))
  
  call_ext(obj, "add", list(title=label,
                            closable=get_properties(obj)$closable,
                            tooltip=tooltip,
                            items=I(sprintf("[%s]", o_id(child)))
                            ))
  ## push to end
  call_ext(obj, "setActiveTab", sprintf("%s.items.length - 1", o_id(obj)))
}

## remove current page
dispose.GNotebook <- function(obj) {
  children <- get_properties(obj)$children
  idx <- svalue(obj)
  update_property(obj, "children", children[-idx])
  set_value(obj, max(0, idx-1))
  
  tpl <- '
  {{{oid}}}.remove({{{oid}}}.getActiveTab());
'
  oid <- o_id(obj)

  push_queue(whisker.render(tpl))
}

## number of children
length.GNotebook <- function(x) length(get_properties(x)$children)

## adjust names
"names<-.GNotebook" <- function(x, value) {
  tpl <- '
  {{{oid}}}.getComponent({{{idx}}}).setTitle("{{nm}}");
'
  oid <- o_id(x)
  f <- function(idx, nm, oid) {
    whisker.render(tpl)
  }
  out <- mapply(f, seq_along(value) - 1, value, oid=oid)
  push_queue(out)
  
  x
}

## set tab number through svalue<-
set_value_js.GNotebook <- function(obj, value) {
  call_ext(obj, "setActiveTab", as.integer(value) - 1)
}

##' chagne is tabchange
##'
##' @inheritParams addHandler
##' @export
##' @rdname gWidgets-handlers
##' @method addHandlerChanged GNotebook
##' @S3method addHandlerChanged GNotebook
addHandlerChanged.GNotebook <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "tabchange", handler, action, ...,
             params="var params = {value: this.items.indexOf(tab) + 1}"
             )
}
  
             
