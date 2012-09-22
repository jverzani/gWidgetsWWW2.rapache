w <- gwindow("gstackwidget")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)


g <- gvbox(cont=w)
bg <- ggroup(cont=g)

gbutton("previous", cont=bg, handler=function(h,...) {
  svalue(sw) <- max(1, svalue(sw) - 1)
})
gbutton("next", cont=bg, handler=function(h,...) {
  message("sw has class ", class(sw))
  message("sw has length ", length(sw))
  message("sw has value class ", class(svalue(sw)))
  
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
glabel("page twp", cont=sw)
glabel("page three", cont=sw)
glabel("page four", cont=sw)
glabel("page five", cont=sw)
