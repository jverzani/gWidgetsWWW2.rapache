\name{addHandler}
\alias{addHandler}
\title{bind a handler to an object for a given signal}
\usage{
  addHandler(obj, signal, handler, action = NULL, ...,
    fn_args = callback_args(signal), params = NULL)
}
\arguments{
  \item{obj}{object that emits signal}

  \item{signal}{signal name}

  \item{handler}{handler. A function with first argument
  which receives a list.}

  \item{action}{object to pass to function call to
  parameterize it}

  \item{...}{passed along}

  \item{fn_args}{argument of javascript function}

  \item{params}{Used internally}
}
\value{
  a handler ID
}
\description{
  bind a handler to an object for a given signal
}

