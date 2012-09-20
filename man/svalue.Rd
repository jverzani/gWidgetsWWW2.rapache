\name{svalue}
\alias{svalue}
\alias{svalue.GCalendar}
\alias{svalue.GCheckbox}
\alias{svalue.GCheckboxGroup}
\alias{svalue.GFrame}
\alias{svalue.GTable}
\alias{svalue.default}
\title{Return main value associated with a widget}
\usage{
  svalue(obj, index = NULL, drop = NULL, ...)

  \method{svalue}{default}(obj, index = NULL, drop = NULL,
    ...)

  \method{svalue}{GFrame}(obj, ...)

  \method{svalue}{GTable}(obj, index = NULL, drop = NULL,
    ...)

  \method{svalue}{GCheckboxGroup}(obj, index = NULL,
    drop = NULL, ...)

  \method{svalue}{GCheckbox}(obj, value)

  \method{svalue}{GCalendar}(obj, ...)
}
\arguments{
  \item{x}{the widget}

  \item{index}{if specified as \code{TRUE} calls
  \code{get_index}, else}

  \item{drop}{passed along, in many cases used like
  \code{drop} call for \code{[}. \code{get_value} reference
  methods.}

  \item{...}{passed to \code{get_value} or \code{get_index}
  method. May include arguments \code{index} or
  \code{drop}}
}
\description{
  Return main value associated with a widget

  svalue method

  svalue method

  svalue method

  svalue method

  svalue method

  svalue method
}

