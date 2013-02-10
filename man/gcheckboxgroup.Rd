\name{gcheckboxgroup}
\alias{gcheckboxgroup}
\title{A group of checkboxes}
\usage{
  gcheckboxgroup(items, checked = FALSE, horizontal = TRUE,
    use.table = FALSE, handler = NULL, action = NULL,
    container = NULL, ..., width = NULL, height = NULL,
    ext.args = NULL, flex = 1,
    label.width = 10 + 10 * max(nchar(items)),
    columns = ifelse(horizontal, length(items), 1))
}
\arguments{
  \item{items}{vector of items to select from}

  \item{checked}{initial value of checked state. Recycled}

  \item{horizontal}{Layout horizontally?}

  \item{use.table}{Needs implementing. If TRUE, uses a grid
  widget with checkboxes to display. If TRUE, horizontal is
  ignored, and items may be a data frame.}

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
  A \code{GCheckboxGroup} reference class instance
}
\description{
  A group of checkboxes
}
\examples{
w <- gwindow()
sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
cbg <- gcheckboxgroup(state.name[1:4], cont=w)
}

