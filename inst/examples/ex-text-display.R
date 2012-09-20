w <- gwindow("Basic widgets")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)

show_value <- function(h,...) {
  galert(svalue(h$action))
}


g <- gvbox(cont=w)
glabel("Widgets for displaying text-based information in gWidgetsWWW2.rapache", cont=g)

## Labels
fr <- gframe("glabel", cont=g, horizontal=FALSE)
label_widget <- glabel("Some label", cont=fr)
bg <- ggroup(cont=fr)
gbutton("svalue", cont=bg, handler=show_value, action=label_widget)
gbutton("svalue<-", cont=bg, handler=function(h, ...) {
  svalue(label_widget) <- "New value"
})

## statusbar
fr <- gframe("gstatusbar", cont=g, horizontal=FALSE)
glabel("Look at bottom of page", cont=fr)
bg <- ggroup(cont=fr)
btn <- gbutton("svalue", cont=bg, handler=show_value, action=sb)
enabled(btn) <- FALSE                   # no svalue method!
gbutton("svalue<-", cont=bg, handler=function(h, ...) {
  svalue(sb) <- "A new value for status bar"
})
gbutton("add a widget", cont=bg, handler=function(h,...) {
  gcombobox(state.name, cont=sb)
})

## html
fr <- gframe("ghtml", cont=g, horizontal=FALSE)
html_widget <- ghtml("
Text with *markdown*
_is_ okay
", markdown=TRUE, cont=fr)
bg <- ggroup(cont=fr)
btn <- gbutton("svalue", cont=bg, handler=show_value, action=html_widget)
enabled(btn) <- FALSE                   # FIX THIS
gbutton("svalue<-", cont=bg, handler=function(h, ...) {
  svalue(html_widget) <- "A new value for ghtml"
})


## separator
fr <- gframe("gseparator", cont=g, horizontal=FALSE)
gseparator(cont=fr)
glabel("Is there another line above me?", cont=fr)
