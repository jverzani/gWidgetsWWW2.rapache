\name{gtable}
\alias{gtable}
\title{gtable}
\usage{
  gtable(items, multiple = FALSE, chosencol = 1,
    handler = NULL, action = NULL, container, ...,
    width = NULL, height = NULL, ext.args = list(),
    store.args = list(),
    selection = if (multiple) "multiple" else "single",
    paging = NULL, col.widths = 1, buffer = 100)
}
\arguments{
  \item{items}{data frame to view. Columns with class
  'Icon' are rendered as icons.}

  \item{multiple}{If \code{TRUE}, then more than one row
  can be selected. See also \code{selection} where a
  checkbox can be provided to make a selection.}

  \item{chosencol.}{By default, \code{svalue} returns this
  column for the selected rows. The \code{drop=FALSE}
  argument may be specified to return the rows.}

  \item{selection}{one of 'single', 'multiple', or
  'checkbox'. Defaults to choice of multiple. The
  'checkbox' options gives intuitive checkboxes for
  selection.}

  \item{col.widths}{A numeric value. Recycled to length
  given by number of columns in \code{items}. The relative
  width of each column.}
}
\description{
  gtable
}

