w <- gwindow("status bar examples")
sb <- gstatusbar("Some status text", cont=w)

g <- gvbox(cont=w)
bg <- ggroup(cont=g, horizontal=TRUE, spacing=5)

gbutton("clear", cont=bg, handler=function(...) {
  svalue(sb) <- ""
})
gbutton("add", cont=bg, handler=function(...) {
  svalue(sb) <- "new text coming"
})
gbutton("show loading", cont=bg, handler=function(...) {
  statusbar_loading(sb, TRUE)
})
gbutton("hide loading", cont=bg, handler=function(...) {
  statusbar_loading(sb, FALSE)
})
addSpring(bg)
gbutton("add widget", cont=bg, handler=function(...) {
  gbutton("new widget", cont=sb, handler=function(h,...) {
    galert('hello')
  })
})



