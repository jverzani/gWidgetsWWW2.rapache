require(canvas)

w <- gwindow("canvas example")
sb <- gstatusbar("Powered by gWidgetsWWW2 and rapache", cont=w)

g <- gvbox(cont=w)

txt <- "
The `gcanvas` widget can be used to display graphics drawn by R's `canvas` package.
Additionally, one can draw canvas primitives to the device. This example
shows the basics.
"

ghtml(txt, markdown=TRUE, cont=g)

width <- 480; height <- 400

bg <- ggroup(cont=g)
btn <- gbutton("new graphic", cont=bg)

cnv <- gcanvas(cont=g, width=width, height=height)
draw <- function(...) {
  f <- tempfile(fileext=".js")
  canvas(f, width=width, height=height)
  hist(rnorm(100))
  dev.off()
  svalue(cnv) <- f
}

addHandlerClicked(btn, draw)
draw()                                  # initial graphic


glabel("To draw a line, click and drag the mouse", cont=g)
addHandlerMouseDown.GCanvas(cnv, handler=function(h,...) {
  . <- function(method, ...) cnv_call_method(cnv, method, ...)
  .("moveTo", h$X, h$Y)
  statusbar_loading(sb, show=TRUE, "'dragging...'")
  started <<- TRUE
})

addHandlerMouseUp.GCanvas(cnv, handler=function(h,...) {
  . <- function(method, ...) cnv_call_method(cnv, method, ...)
  if(started) {
    .("lineTo", h$X, h$Y)
    .("stroke")
  }
  statusbar_loading(sb, show=FALSE)
  started <<- FALSE
})

