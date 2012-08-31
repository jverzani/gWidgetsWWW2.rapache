##' @include gcomponent.R
NULL

##' Container for an image
##'
##' The image shows an image file. Use \code{ghtml} with the "img" tag to show a url
##' @param filename an image file.
##' @param size A vector passed to \code{width} and \code{height} arguments.
##' @inheritParams gwidget
##' @export
##' @examples
##' w <- gwindow("hello", renderTo="replaceme")
##' sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
##' g <- ggroup(cont=w, horizontal=FALSE)
##' 
##' f <- tempfile()
##' png(f)
##' hist(rnorm(100))
##' dev.off()
##' 
##' i <- gimage(f, container=g)
##' b <- gbutton("click", cont=g, handler=function(h,...) {
##'   f <- tempfile() 
##'   png(f)
##'   hist(rnorm(100))
##'   dev.off()
##'   svalue(i) <- f
##' })
##' @note requires tempdir to be mapped to a specific url, as this is
##' assumed by \code{get_tempfile} and \code{get_tempfile_url}
gsvg <- function(filename = "", 
                 container = NULL,...,
                 width=480, height=400, ext.args=NULL
                 ) {
  

  
  obj <- new_item()
  class(obj) <- c("GSvg",  "GWidget", "GComponent", class(obj))
  
  ## for proxy objects we set values somewhere and record filename
  f <- tempfile(fileext=".svg")
  set_vals(obj, items=f, properties=list(width=width, height=height))

  if(file.exists(filename))
    file.copy(filename, f, overwrite=TRUE)
  
  constructor <- "Ext.Component"
  args <- list(html=.get_svg_url(obj),
               width=width, height=height
               )
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))
  
  ## add
  add(container, obj, ...)

  obj
  
  
  

}

set_value_js.GSvg <- function(obj, value) {
  if(!file.exists(value))
    return()
  file <- get_items(obj)
  file.copy(value, file, overwrite=TRUE)
  call_ext(obj, "update", shQuote(.get_svg_url(obj)))
}

.get_svg_url <- function(obj) {
  f <- get_items(obj)
  if(is.na(file.info(f)$size))
    return("no file specified")
  
  ID <- ..e..$..ID..                    # gloabl
  tmp <- get_properties(obj)
  width <- tmp$width; height <- tmp$height
  
  whisker.render("<embed {{#width}}width={{width}}{{/width}} {{#height}}height={{height}}{{/height}} src='temp_file?ID={{ID}}&obj={{obj}}' type='image/svg+xml'/>") # url_base
}

