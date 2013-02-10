\name{gradio}
\alias{gradio}
\title{Radio button group}
\usage{
  gradio(items, selected = 1, horizontal = TRUE,
    handler = NULL, action = NULL, container = NULL, ...,
    width = NULL, height = NULL, ext.args = NULL, flex = 1,
    label.width = 10 + 10 * max(nchar(items)),
    columns = ifelse(horizontal, length(items), 1))
}
\arguments{
  \item{items}{Vector of items to choose one from.}

  \item{selected}{index of initially selected item}

  \item{horizontal}{logical. Horizontal or vertical layout.
  (See also columns)}

  \item{columns}{Can be used to override horizontal TRUE or
  FALSE}
}
\value{
  a \code{GRadio} reference class object
}
\description{
  A basic radio button group. Specify the labels through
  items. The main value is the label or index.
}
\note{
  the \code{[<-} method (to change the labels) is not
  implemented. The radio labels look better in horizontal
  box containers than vertical ones.
}

