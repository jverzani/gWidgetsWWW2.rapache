
##' Mark a character as an Icon
##'
##' We use the class "Icon" to mark icons, which are css classnames or URLs
##' @param x a character vector to mark with additional class of "Icon"
##' @return same object with new class
##' @export
asIcon <- function(x) {
  class(x) <- c("Icon", class(x))
  x
}

##' Is this an icon? (has class Icon)
##' @param x object
##' @return logical
##' @export
isIcon <- function(x) is(x,"Icon")

## an evironment to hold names of stock icons
..icon_list.. <- new.env()
icon <- list.files(system.file("icons", package="gWidgetsWWW2.rapache"), full=TRUE)
icon <- Filter(function(x) grepl("\\.png$",x), icon)
nm <- gsub("\\.png$", "", basename(icon))
sapply(nm, function(i) ..icon_list..[[i]] <- TRUE)

##' return CSS class of icon
get_stock_icon_by_name <- function(value) {
  if(is.null(value)) return(NULL)
  if(!is.null(..icon_list..[[value]]))
    whisker.render("x-gw-icon-{{{value}}}")
  else
    NULL
}

##' add stock icons
##' ## add some stock icons
##'
##' @examples
##' icon <- list.files(system.file("icons", package="gWidgetsWWW2.rapache"), full=TRUE)
##' icon <- Filter(function(x) grepl("\\.png$",x), icon)
##' nm <- gsub("\\.png$", "", basename(icon))
##' icon_css <- addStockIcons(nm, icon)
addStockIcons <- function(iconNames, iconFiles) {
  ## make data:image... for each file, add somehow to CSS
  ## we need a queue to store icons
  sprintf("Ext.util.CSS.createStyleSheet('%s');",
                 paste(mapply(icon_css, iconNames, iconFiles), collapse="\n"))
}


icon_css <- function(nm, icon) {
  ## if URL do one thing, if file do another

  tpl <- ".x-gw-icon-{{nm}} {background-image: url({{{icon}}}) !important; background-repeat:no-repeat;background-position:center;}"

  ..icon_list..[[nm]] <- icon           # store name
  if(!isURL(icon))
    icon <- markdown:::.b64EncodeFile(icon)
  
  whisker.render(tpl)
}
