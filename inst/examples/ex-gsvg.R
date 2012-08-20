w <- gwindow("gsvg")
sb <- gstatusbar("Powered by gWidgetsWWW2 and rapache", cont=w)

g <- gvbox(cont=w, use.scrollwindow=TRUE)


device <- gsvg(cont=g, width=480, height=400)



handler <- function(...) {
  f <- tempfile()
  svg(file=f)
  hist(rnorm(100))
  dev.off()
  svalue(device) <- f
}

bg <- ggroup(cont=g)
btn <- gbutton("click", cont=bg, handler=handler)

## initial graphic
handler()
