\name{gfile}
\alias{gfile}
\title{File selection form}
\usage{
  gfile(text = "Choose a file", type = c("open"),
    filter = NULL, handler = NULL, action = NULL,
    container = NULL, ..., width = NULL, height = NULL,
    ext.args = NULL)
}
\arguments{
  \item{text}{Instructional text.}

  \item{type}{only "open" implemented}

  \item{filter}{ignored}
}
\value{
  a \code{GFile} instance
}
\description{
  This renders a file selection form within a small panel
  widget. There are two steps needed to transfer a file: a)
  select a file through a dialog, b) save the file to the
  server by clicking the upload button.
}
\note{
  the \code{svalue} method returns the temporary filename
  of the uploaded file, or a value of \code{NA}. The
  property \code{filename} holds the original filename.
}
\examples{
w <- gwindow()
gstatusbar("Powered by gWidgetsWWW2 and Rook", cont=w)
f <- gfile("Choose a file for upload", cont=w, handler=function(h,...) {
  galert(paste("You uploaded", svalue(h$obj)), parent=w)
})
}

