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

