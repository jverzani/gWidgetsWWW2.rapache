w <- gwindow("gcheckbox")
sb <- gstatusbar("Powered by gWidgetsWWW2 and rapache", cont=w)


g <- gvbox(cont=w)
bg <- ggroup(cont=g)

gbutton("svalue", cont=bg, handler=function(h,...) {
  push_queue(sprintf("alert('%s');", svalue(cb1)))
})
gbutton("svalue<-, FALSE", cont=bg, handler=function(h,...) {
  svalue(cb1) <-FALSE
})

gbutton("svalue<-, TRUE", cont=bg, handler=function(h,...) {
  svalue(cb1) <- TRUE
})
gbutton("enabled", cont=bg, handler=function(h,...) {
  enabled(cb1) <- TRUE
})
gbutton("disabled", cont=bg, handler=function(h,...) {
  enabled(cb1) <- FALSE
})


fl <- gformlayout(cont=g)
cb1 <- gcheckboxgroup(c("label 1", "label2"), checked=TRUE, cont=fl, label="basic")
#cb1 <- gcheckbox("", checked=TRUE, cont=fl, label="no label")
