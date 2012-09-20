w <- gwindow("gcheckbox")
sb <- gstatusbar("Powered by gWidgetsWWW2 and rapache", cont=w)


g <- gvbox(cont=w)
bg <- ggroup(cont=g)

gbutton("svalue", cont=bg, handler=function(h,...) {
  galert(svalue(cb1))
})
gbutton("svalue<-, value, 1", cont=bg, handler=function(h,...) {
  svalue(cb1) <- "label 1"
})

gbutton("svalue<-, index, 1:2", cont=bg, handler=function(h,...) {
  svalue(cb1, index=TRUE) <- 1:2
})
gbutton("svalue<-, logical 1,0", cont=bg, handler=function(h,...) {
  svalue(cb1) <- c(T,F)
})

gbutton("names", cont=bg, handler=function(h,...) {
  names(cb1) <- c("LABEL ONE", "label two")
})

gbutton("enabled", cont=bg, handler=function(h,...) {
  enabled(cb1) <- TRUE
})
gbutton("disabled", cont=bg, handler=function(h,...) {
  enabled(cb1) <- FALSE
})


gbutton("checkbox value", cont=bg, handler=function(h,...) {
  push_queue(sprintf("alert('%s');", svalue(cb3)))
})

fl <- gformlayout(cont=g)
cb1 <- gcheckboxgroup(c("label 1", "label2"), checked=FALSE, cont=fl, label="basic")
cb2 <- gcheckboxgroup(c("label 1", "label2"), horizontal=TRUE, checked=TRUE, cont=fl, label="basic")
cb3 <- gcheckbox("one label", checked=FALSE, cont=fl, label="checkbox")
