\name{gbasicdialog}
\alias{gbasicdialog}
\title{a basic dialog is just a vertical box container with a dismiss button}
\usage{
  gbasicdialog(title, parent, ...)
}
\arguments{
  \item{title}{title of window}

  \item{parent}{parent window}

  \item{...}{passed to gwindow call}
}
\description{
  a basic dialog is just a vertical box container with a
  dismiss button
}
\examples{
w <- gwindow("parent")
b <- gbutton("click me", cont=w, handler=function(h,...) {
  g <- gbasicdialog("some dialog", parent=w)
  gtable(mtcars, cont=g)
})
}

