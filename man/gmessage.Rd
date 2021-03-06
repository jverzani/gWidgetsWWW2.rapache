\name{gmessage}
\alias{gmessage}
\title{A simple message dialog.}
\usage{
  gmessage(message, title = "message", icon = NULL,
    parent = NULL, ...)
}
\arguments{
  \item{message}{main message.}

  \item{title}{Title for dialog's window}

  \item{icon}{icon to decorate dialog. One of
  \code{c("info", "warning", "error", "question")}.}

  \item{parent}{ignored}

  \item{...}{ignored}
}
\value{
  return value ignored
}
\description{
  A simple message dialog.
}
\examples{
w <- gwindow()
gbutton("click me for a message", cont=w, handler=function(h,...) {
gmessage("Hello there", parent=w)
})
}

