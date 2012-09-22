w <- gwindow("gsvg")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)

g <- gvbox(cont=w, use.scrollwindow=TRUE)
ghtml("
The `gsvg` constructor can be used to show svg files. This example shows
how it can be used in combination with the `svg` device to display
graphical output. The display is sharp (as opposed to `gcanvas` say) but
refreshing does flicker, as can be seen here when the 'click' button is
pressed to refresh the graphic
", cont=g)

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
