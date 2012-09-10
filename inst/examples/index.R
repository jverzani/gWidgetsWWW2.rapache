w <- gwindow("gWidgetsWWW2.rapache")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)

## show links for about, ...

files <- list.files(system.file("examples", package="gWidgetsWWW2.rapache"), full=TRUE)
files <- Filter(function(i) basename(i) != "index.R", files)

vb <- gvbox(cont=w)
glabel("<h3>gWidgetsWWW2.rapache examples</h3>", cont=vb)
glabel("Click the buttons below to view some examples of gWidgetsWWW2.rapache.",
       cont=vb)


Map(function(x) {
  nm <- basename(x)
  g <- ggroup(cont=vb)
  gbutton("Source", cont=g, handler=function(h,...) {
    w1 <- gbasicdialog(sprintf("Source of %s", nm), parent=w)
    txt <- paste(readLines(x), collapse="\n")
    gtext(txt, cont=w1)
    visible(w1) <- TRUE
  })

  gbutton("Run example", cont=g, handler=function(h, ...) {
    push_queue(sprintf("window.open('%s', '_blank');window.focus();", nm))
  })

  glabel(nm, cont=g)
}, files)
