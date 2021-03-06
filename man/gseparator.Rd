\name{gseparator}
\alias{gseparator}
\title{Separator -- insert separator line}
\usage{
  gseparator(horizontal = TRUE, container = NULL, ...)
}
\arguments{
  \item{horizontal}{Logical. Ignored, not vertical line
  possible}

  \item{container}{parent container. Not used if creating
  menu or toolbar separator}

  \item{...}{passed to \code{add} method of parent
  container}
}
\description{
  Used in menus to create space. No container necessary Can
  also be used to place horizontal line using the \code{hr}
  HTML tag
}

