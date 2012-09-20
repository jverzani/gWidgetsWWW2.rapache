\name{gcheckboxgroup}
\alias{gcheckboxgroup}
\title{A group of checkboxes}
\usage{
  gcheckboxgroup(items, checked = FALSE, horizontal = TRUE,
    use.table = FALSE, handler = NULL, action = NULL,
    container = NULL, ..., width = NULL, height = NULL,
    ext.args = NULL, flex = 1,
    columns = ifelse(horizontal, length(items), 1))
}
\arguments{
  \item{items}{vector of items to select from}

  \item{checked}{initial value of checked state. Recycled}

  \item{horizontal}{Layout horizontally?}

  \item{use.table}{Needs implementing. If TRUE, uses a grid
  widget with checkboxes to display. If TRUE, horizontal is
  ignored, and items may be a data frame.}
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

