w <- gwindow("gnotebook")
sb <- gstatusbar("Powered by gWidgetsWWW2 and rapache", cont=w)


g <- gvbox(cont=w)
bg <- ggroup(cont=g)

gbutton("previous", cont=bg, handler=function(h,...) {
  svalue(nb) <- max(1, svalue(nb) - 1)
})
gbutton("next", cont=bg, handler=function(h,...) {
  svalue(nb) <- min(length(nb), svalue(nb) + 1)
})
gbutton("page two", cont=bg, handler=function(h,...) {
  svalue(nb) <- 2
})
gbutton("dispose", cont=bg, handler=function(h,...) {
  dispose(nb)
})
gbutton("add", cont=bg, handler=function(h,...) {
  glabel("new page", cont=nb, label="Tab new")
})
gbutton("length", cont=bg, handler=function(h,...) {
  push_queue(sprintf("alert('There are %s tabs')", length(nb)))
})
gbutton("names<-", cont=bg, handler=function(h,...) {
  names(nb)[1] <- "NEW NAME"
})


nb <- gnotebook(cont=g)

sapply(c("one", "two", "three", "four", "five"), function(i) {
  glabel(sprintf("page %s", i), label=sprintf("Tab %s", i), cont=nb)
})
