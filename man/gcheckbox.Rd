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

  \item{handler}{optional handler bound via
  \code{addHandlerChanged}}

  \item{action}{optional value to paramaterize handler}

  \item{container}{parent container}

  \item{...}{passed along to \code{add} call of the
  container. Can be used to adjust layout parameters. May
  also have other uses.}

  \item{width}{a pre-specified width (in pixels) for the
  widget}

  \item{height}{a pre-specified height (in pixels) for the
  widget}

  \item{ext.args}{A list of extra arguments to pass to the
  ExtJS constructor}
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

