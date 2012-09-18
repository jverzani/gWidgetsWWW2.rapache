txt <- "
Filtering a table can be achieved through `gtable` `visible<-` method. This
example shows how it can be done.
"

m <- mtcars[, c("mpg", "wt", "cyl")]

## let's go...
w <- gwindow("filter")
gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)
g <- gvbox(cont=w)

ghtml(txt, markdown=TRUE, cont=g)
bg <- ggroup(cont=g)
glabel("Filter by cylinders == ", cont=bg)
no_filter <- "no filter"
cb <- gcombobox(c(no_filter, sort(unique(m$cyl))), cont=bg)
## handler to call visible as appropriate
addHandlerChanged(cb, handler=function(h, ...) {
  val <- svalue(h$obj)
  if(val != no_filter) {
    ind <- tbl[,'cyl'] == as.numeric(val)
  } else {
    ind <- rep(TRUE, dim(tbl)[1])
  }
  visible(tbl) <- ind
})
## some way to check selection works
gbutton("show selected value", cont=bg, handler=function(h,...) {
  galert(svalue(tbl))
})
## the table widget
tbl <- gtable(m, cont=g)
