\name{gcheckbox}
\alias{gcheckbox}
\title{checkbox widget}
\usage{
  gcheckbox(text = "", checked = FALSE,
    use.togglebutton = FALSE, handler = NULL,
    action = NULL, container = NULL, ..., width = NULL,
    height = NULL, ext.args = NULL)
}
\arguments{
  \item{text}{character. text label for checkbox.}

  \item{checked}{logical. initial state (Set later with
  \code{svalue<-})}

  \item{use.togglebutton}{logical. XXX not implemented If
  TRUE, represent with a togglebutton, else use check box}
}
\description{
  checkbox widget
}
\note{
  No method to set label
}
\examples{
w <- gwindow()
sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
cb <- gcheckbox("Check me?", cont=w, handler=function(h,...) if(svalue(h$obj)) galert("checked", parent=w))
}

