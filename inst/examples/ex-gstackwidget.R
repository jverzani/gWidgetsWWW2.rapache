## The stackwidget is also known as a card layout. It is like a notebook container, but has no
## tabs for the user to toggle between pages. Rather this is done through user actions programmed
## by the programmer. It can be used to preload pages pushing the lag to the initial page load. The
## "about.R" example and the "ex-gfile.R" example employ this widget.

w <- gwindow("gstackwidget")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)


g <- gvbox(cont=w)
ghtml("
The `gstackwidget` container allows multiple child components to be loaded while showing
just one at a time. This is similar to the `gnotebook` widget, except there are no
tabs drawn to toggle the pages. Rather, this is done programmatically. In this example,
the buttons are used to switch.
", markdown=TRUE, cont=g)

bg <- ggroup(cont=g)

gbutton("previous", cont=bg, handler=function(h,...) {
  svalue(sw) <- max(1, svalue(sw) - 1)
})
gbutton("next", cont=bg, handler=function(h,...) {
  svalue(sw) <- min(length(sw), svalue(sw) + 1)
})
gbutton("page two", cont=bg, handler=function(h,...) {
  svalue(sw) <- 2
})
gbutton("remove page two", cont=bg, handler=function(h,...) {
  delete(sw, index=2)
})


sw <- gstackwidget(cont=g)

glabel("page one", cont=sw)
glabel("page two", cont=sw)
glabel("page three", cont=sw)
glabel("page four", cont=sw)
glabel("page five", cont=sw)
