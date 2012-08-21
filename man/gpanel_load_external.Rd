\name{gpanel_load_external}
\alias{gpanel_load_external}
\title{Load urls then run callback}
\usage{
  gpanel_load_external(obj, url, callback)
}
\arguments{
  \item{obj}{gpanel object}

  \item{url}{vector of urls to load}

  \item{callback}{if specified, a javascript callback.
  Otherwise, calls any handlers specified through
  \code{addHandlerChanged}}
}
\description{
  Load urls then run callback
}

