\name{gtext}
\alias{gtext}
\title{A text area widget}
\usage{
  gtext(text = "", width = NULL, height = 300,
    font.attr = NULL, wrap = TRUE, handler = NULL,
    action = NULL, container = NULL, ..., ext.args = NULL,
    grow = FALSE)
}
\arguments{
  \item{text}{initial text. There is an issue with single
  quotes -- avoid them.}

  \item{width}{width in pixels}

  \item{height}{height in pixels}

  \item{font.attr}{Ignored. Default font attributes}

  \item{wrap}{Ignored Do we wrap the text}

  \item{handler}{optional handler bound via
  \code{addHandlerChanged}}

  \item{action}{optional value to paramaterize handler}

  \item{container}{parent container}

  \item{...}{passed along to \code{add} call of the
  container. Can be used to adjust layout parameters. May
  also have other uses.}

  \item{ext.args}{A list of extra arguments to pass to the
  ExtJS constructor}
}
\value{
  an ExtWidget instance
}
\description{
  XXX: there is an issue with single quotes.
}
\examples{
w <- gwindow("gtext example")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)
g <- ggroup(cont=w, horizontal=FALSE)
txt <- gtext("Some text with \\n new lines", cont=g)
b <- gbutton("click", cont=g, handler=function(h,...) {
  galert(svalue(b), parent=w)
})
 b <- gbutton("change", cont=g, handler=function(h,...) {
   svalue(txt) <- "some new text"
})
}

