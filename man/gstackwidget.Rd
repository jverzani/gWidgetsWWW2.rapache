\name{gstackwidget}
\alias{gstackwidget}
\title{stack widget is a "card" container. Use \code{gnotebook} methods to change cards}
\usage{
  gstackwidget(container, ..., width = NULL, height = NULL,
    ext.args = NULL)
}
\value{
  a GStackWidget reference class object.
}
\description{
  stack widget is a "card" container. Use \code{gnotebook}
  methods to change cards
}
\examples{
w <- gwindow()
sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
g <- gstackwidget(cont=w)
gbutton("page 1. Next", cont=g, handler=function(h,...) svalue(g) <- svalue(g) + 1)
gbutton("page 2. Next", cont=g, handler=function(h,...) svalue(g) <- svalue(g) + 1)
gbutton("remove me", cont=g, handler=function(h,...) dispose(g))
gbutton("page 3. First", cont=g, handler=function(h,...) svalue(g) <- 1)
svalue(g) <- 1
}

