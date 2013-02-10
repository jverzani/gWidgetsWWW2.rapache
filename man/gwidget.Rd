\name{gwidget}
\alias{gwidget}
\title{widget template}
\usage{
  gwidget(handler = NULL, action = NULL, container, ...,
    ext.args = list(), width, height)
}
\arguments{
  \item{handler}{optional handler bound via
  \code{addHandlerChanged}}

  \item{action}{optional value to paramaterize handler}

  \item{container}{parent container}

  \item{...}{passed along to \code{add} call of the
  container. Can be used to adjust layout parameters. May
  also have other uses.}

  \item{ext.args}{A list of extra arguments to pass to the
  ExtJS constructor}

  \item{width}{a pre-specified width (in pixels) for the
  widget}

  \item{height}{a pre-specified height (in pixels) for the
  widget}
}
\value{
  returns an object with various methods defined
}
\description{
  Document standard arguments for a widget
}

