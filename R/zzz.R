## anything here?
.onLoad <- function(libname, pkgname) {

  packageStartupMessage(sprintf("
gWidgetsWWW2.rapache. This package is usually started only by `rapache`.
To read details of the package, issue this command:

  browseURL('%s')
", system.file("docs", "gWidgetsWWW2_rapache.html", package="gWidgetsWWW2.rapache")), appendLF = FALSE)
  
}
