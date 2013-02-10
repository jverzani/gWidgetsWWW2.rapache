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

