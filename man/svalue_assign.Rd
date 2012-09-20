\name{svalue<-}
\alias{svalue<-}
\alias{svalue<-.GCalendar}
\alias{svalue<-.GCheckboxGroup}
\alias{svalue<-.GCheckboxTable}
\alias{svalue<-.GFrame}
\alias{svalue<-.GTable}
\alias{svalue<-.GWidgetTextProxy}
\alias{svalue<-.default}
\title{Set main value associated with a widget}
\usage{
  svalue(obj, index = FALSE, ...) <- value

  \method{svalue}{default}(obj, index = FALSE, ...) <-
    value

  \method{svalue}{GFrame}(obj, ...) <- value

  \method{svalue}{GWidgetTextProxy}(obj, ...) <- value

  \method{svalue}{GTable}(obj, index = NULL, ...) <- value

  \method{svalue}{GCheckboxGroup}(obj, index = NULL, ...)
    <- value

  \method{svalue}{GCalendar}(obj, ...) <- value

  \method{svalue}{GCheckboxTable}(obj, index = NULL, ...)
    <- value
}
\arguments{
  \item{x}{object}

  \item{index}{if non-NULL and \code{TRUE} call
  \code{set_index} else call \code{set_value} reference
  class method.}

  \item{...}{passed to \code{set_value} method. May include
  arguments for \code{index}}

  \item{value}{value to set}
}
\description{
  Set main value associated with a widget

  assignment method for svalue

  assignment method for svalue

  assignment method for svalue

  assignment method for svalue

  assignment method for svalue

  assignment method for svalue

  assignment method for svalue
}

