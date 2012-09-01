\name{gtimer}
\alias{gtimer}
\title{Basic timer widget}
\usage{
  gtimer(ms, FUN, data = NULL, one.shot = FALSE,
    start = TRUE, toolkit = guiToolkit())
}
\arguments{
  \item{ms}{interval in milliseconds}

  \item{FUN}{FUnction to call. Has one argument, data
  passed in}

  \item{data}{passed to function}

  \item{one.shot}{logical. If TRUE, called just once, else
  repeats}

  \item{toolkit}{gui toolkit to dispatch into}
}
\description{
  Calls FUN every ms/1000 seconds.
}

