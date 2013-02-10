\name{gspinbutton}
\alias{gspinbutton}
\title{Basic spinbutton}
\usage{
  gspinbutton(from = 0, to = 100, by = 1, value = from,
    handler = NULL, action = NULL, container = NULL, ...,
    width = NULL, height = NULL, ext.args = NULL)
}
\arguments{
  \item{from}{from value}

  \item{to}{to}

  \item{by}{by. From to by are same as seq() usage}

  \item{value}{initial value}

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
\value{
  an GSpinbutton reference class instance
}
\description{
  Basic spinbutton
}
\examples{
w <- gwindow()
sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
sp <- gspinbutton(cont=w)
}

