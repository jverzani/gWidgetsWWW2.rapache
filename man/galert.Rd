\name{galert}
\alias{galert}
\title{quick alert message -- not modal or obtrusive (dropped from above in extjs)}
\usage{
  galert(msg, title = NULL, delay = 3, ...)
}
\arguments{
  \item{message}{message to display}

  \item{title}{title of message, if given}

  \item{delay}{delay in seconds}
}
\value{
  no return value
}
\description{
  quick alert message -- not modal or obtrusive (dropped
  from above in extjs)
}
\examples{
w <- gwindow()
b <- gbutton("click me", cont=w, handler=function(h,...) {
  galert("alot", title="That hurt")
})
}

