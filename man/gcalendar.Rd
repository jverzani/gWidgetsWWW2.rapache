\name{gcalendar}
\alias{gcalendar}
\title{calendar widget}
\usage{
  gcalendar(text = "", format = NULL, handler = NULL,
    action = NULL, container = NULL, ..., width = NULL,
    height = NULL, ext.args = NULL)
}
\arguments{
  \item{text}{optional inital date as text.}

  \item{format}{format of date. Default of Y-m-d.}
}
\value{
  a \code{GCalendar} instance
}
\description{
  Basic text box with button to open calendar picker
  dialog. The svalue method refers to the date, which
  depends on the value of \code{format}.
}
\note{
  the \code{svalue} method returns an instance of
  \code{Date} class by conversion through \code{as.Date}.
}
\examples{
w <- gwindow("Calendar")
sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
a <- gcalendar(cont=w)
}

