w <- gwindow("gradio")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)


g <- gvbox(cont=w)
bg <- ggroup(cont=g)

gbutton("svalue", cont=bg, handler=function(h,...) {
  galert(svalue(rb1))
})
gbutton("svalue<-, 3", cont=bg, handler=function(h,...) {
  svalue(rb1) <- state.name[3]
})

gbutton("svalue<-, index, 2", cont=bg, handler=function(h,...) {
  svalue(rb1, index=TRUE) <- 2
})
gbutton("enabled", cont=bg, handler=function(h,...) {
  enabled(rb1) <- TRUE
})
gbutton("disabled", cont=bg, handler=function(h,...) {
  enabled(rb1) <- FALSE
})


fl <- gformlayout(cont=g)
rb1 <- gradio(state.name[1:4], horizontal=TRUE, cont=fl, label="horizontal")
rb2 <- gradio(state.name[1:4], horizontal=FALSE, cont=fl, label="vertical")
rb3 <- gradio(state.name[1:4], horizontal=TRUE, cont=fl, flex=NULL, label="flex=NULL")


addHandlerChanged(rb3, function(h, ...) {
  val <- svalue(h$obj)
  galert(val)
})
