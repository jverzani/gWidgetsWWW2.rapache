\name{gsvg}
\alias{gsvg}
\title{Container for an image}
\usage{
  gsvg(filename = "", container = NULL, ..., width = 480,
    height = 400, ext.args = NULL)
}
\arguments{
  \item{filename}{an image file.}

  \item{size}{A vector passed to \code{width} and
  \code{height} arguments.}

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
  The image shows an image file. Use \code{ghtml} with the
  "img" tag to show a url
}
\note{
  requires tempdir to be mapped to a specific url, as this
  is assumed by \code{get_tempfile} and
  \code{get_tempfile_url}
}
\examples{
w <- gwindow("hello", renderTo="replaceme")
sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
g <- ggroup(cont=w, horizontal=FALSE)

f <- tempfile()
png(f)
hist(rnorm(100))
dev.off()

i <- gimage(f, container=g)
b <- gbutton("click", cont=g, handler=function(h,...) {
  f <- tempfile()
  png(f)
  hist(rnorm(100))
  dev.off()
  svalue(i) <- f
})
}

