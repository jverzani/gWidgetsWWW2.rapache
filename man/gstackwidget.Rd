\name{gstackwidget}
\alias{gstackwidget}
\title{stack widget is a "card" container. Use \code{gnotebook} methods
to change cards}
\usage{
  gstackwidget(container, ..., width = NULL, height = NULL,
    ext.args = NULL)
}
\arguments{
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
  See ex-gstackwidget.R for an example
}

