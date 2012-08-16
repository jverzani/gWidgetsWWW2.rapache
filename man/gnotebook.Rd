\name{gnotebook}
\alias{gnotebook}
\title{Notebook container}
\usage{
  gnotebook(tab.pos = 3, close.buttons = FALSE, container,
    ..., width = NULL, height = NULL, ext.args = NULL)
}
\arguments{
  \item{tab.pos}{where to place tabs. A value of 1 is the
  bottom, else the top.}

  \item{close.buttons}{Logical. Are there close buttons on
  the tabs}
}
\description{
  Notebook container
}
\examples{
w <- gwindow()
nb <- gnotebook(cont=w)
gbutton("hello", container=nb, label="My label") ## pass in label argument through ... to \\code{add}
gbutton("page 2", container=nb, label="page 2")
svalue(nb) <- 1
}
\seealso{
  The \code{\link{gstackwidget}} container is similar, but
  has no tabs.
}

