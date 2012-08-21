\name{addStockIcons}
\alias{addStockIcons}
\title{add stock icons
## add some stock icons}
\usage{
  addStockIcons(iconNames, iconFiles)
}
\description{
  add stock icons ## add some stock icons
}
\examples{
icon <- list.files(system.file("icons", package="gWidgetsWWW2.rapache"), full=TRUE)
icon <- Filter(function(x) grepl("\\\\.png$",x), icon)
nm <- gsub("\\\\.png$", "", basename(icon))
icon_css <- addStockIcons(nm, icon)
}

