\name{gslider}
\alias{gslider}
\title{slider widget}
\usage{
  gslider(from = 0, to = 100, by = 1, value = from,
    horizontal = TRUE, handler = NULL, action = NULL,
    container = NULL, ..., width = NULL, height = NULL,
    ext.args = NULL, tpl = "{0}")
}
\arguments{
  \item{from}{starting point. Unlike other implementations
  for gWidgets, this is not possibly a vector specifying a
  range of values to slide over.}

  \item{to}{ending point}

  \item{by}{step size. Must be larger than 1 and even then
  will round to integer value}

  \item{value}{initial value}

  \item{horizontal}{orientation}

  \item{tpl}{Template for tooltip. Should have "\code{{0}}"
  to replace the value, but can have more formatting}
}
\description{
  Use slider to select from a sequence of values, specified
  as with \code{seq}. The sequence steps must be greater
  than 1
}
\note{
  The slider updates on "changecomplete", not the more
  common "change". The "change" signal happens too often
  for the transferral of values to work reliably.  the
  database can process so these should be used sparingly.
}

