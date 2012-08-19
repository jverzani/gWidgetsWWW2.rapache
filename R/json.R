asJSON <- function(x, ...) UseMethod("asJSON")
asJSON.default <- function(x, ...) {
  if(length(x) == 1) {
    shQuote(x)
  } else {
    toJSON(x)
  }
}
asJSON.numeric <- function(x, ...) {
  if(length(x) == 1)
    format(x)
  else
    toJSON(x)
}
asJSON.AsIs <- function(x, ...) {cat("ASIS"); whisker.render("{{{x}}}") }# no quotes?
asJSON.list <- function(x, ...) sprintf("{%s}",
                                        paste(mapply(function(key, value) {
                                          value <- asJSON(value);
                                          whisker.render("{{key}}: {{{value}}}")
                                        },
                                                     names(x), x),
                                              collapse=","))

