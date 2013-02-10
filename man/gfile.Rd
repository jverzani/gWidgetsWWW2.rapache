\name{gfile}
\alias{gfile}
\title{File selection form}
\usage{
  gfile(text = "Choose a file", type = c("open"),
    filter = NULL, handler = NULL, action = NULL,
    container = NULL, ..., width = NULL, height = NULL,
    ext.args = NULL, fieldlabel = NULL,
    placeholder = gettext("Select a file..."),
    upload.message = gettext("Uploading your file ..."))
}
\arguments{
  \item{text}{Instructional text.}

  \item{type}{only "open" implemented}

  \item{filter}{ignored}

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
  a \code{GFile} instance
}
\description{
  This renders a file selection form within a small panel
  widget. There are two steps needed to transfer a file: a)
  select a file through a dialog, b) save the file to the
  server by clicking the upload button.
}
\details{
  When a file is uploaded, any change handlers are called.

  The \code{svalue} method gives the path of the uploaded
  file, the \code{[} method gives the original name of the
  file when uploaded.
}
\note{
  the \code{svalue} method returns the temporary filename
  of the uploaded file, or a value of \code{""}. The
  \code{[} method gives the original filename, once one is
  uploaded.
}
\examples{
w <- gwindow()
gstatusbar("Powered by gWidgetsWWW2 and Rook", cont=w)
f <- gfile("Choose a file for upload", cont=w, handler=function(h,...) {
  galert(paste("You uploaded", svalue(h$obj)), parent=w)
})
}

