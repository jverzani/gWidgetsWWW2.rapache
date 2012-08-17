\name{gborderlayout}
\alias{gborderlayout}
\title{A "border" layout is a 5-panel layout where  satellite panels
surround a "center" panel.}
\usage{
  gborderlayout(container, ..., width = "100\%",
    height = "100\%", ext.args = NULL, title = list(),
    collapsible = list())
}
\arguments{
  \item{title}{a list with named components from
  \code{c("center","north", "south", "east", "west")}
  allowing one to specify titles (as length-1 character
  vectors) of the regions. The default is no title. A title
  may be added later by adding a \code{gframe} instance,
  but that won't work well with a collapsible panel.}

  \item{collapsible}{a list with named components from
  \code{c("center","north", "south", "east", "west")}
  allowing one to specify through a logical if the panel
  will be collapsible, similar to \code{gexpandgroup}. The
  default is \code{FALSE}}
}
\value{
  a \code{GBorderLayout} reference class object
}
\description{
  The \code{gborderlayout} container implements a border
  layout where 4 panels surround a main center panel. The
  panels may be configured with a title (like
  \code{gframe}) and may be collapsible (like
  \code{gexpandgroup}). Both configurations are done at
  construction time. The panels only hold one child, so one
  would add a container to have more complicated layouts.
}
\details{
  To add a child component, one specifies a value of
  \code{where} to the \code{add} method (implicitly called
  by the constructor, so in practice this argument is
  passed through \code{...} by the constructor). The value
  of \code{where} is one of \code{c("center","north",
  "south", "east", "west")}. Child components are added
  with the "fit" layout, which is basically the same as
  specifying \code{expand=TRUE} and \code{fill=TRUE},
  though those arguments are ignored here.

  The satellite panels may be resized through the reference
  class method \code{set_panel_size} with arguments
  \code{where} and a numeric \code{dimension}.
}
\note{
  \code{gpanedgroup} does not sit nicely within a
  \code{gnotebook} container, avoid trying this.
}
\author{
  john verzani
}
\seealso{
  \code{\link{gpanedgroup}} is a two-panel border layout
  with just an "east" or "south" satellite panel
  configured.
}

