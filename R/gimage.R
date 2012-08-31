##' @include gcomponent.R
NULL

##' Container for an image
##'
##' The image shows an image file. Use \code{ghtml} with the "img" tag to show a url
##' @param filename an image file.
##' @param dirname ignored.
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
gimage <- function(filename = "", dirname = "",  size = NULL,
                   handler = NULL, action = NULL, container = NULL,...,
                   width=NULL, height=NULL, ext.args=NULL
                   ) {


  
  obj <- new_item()
  class(obj) <- c("GImage",  "GWidget", "GComponent", class(obj))
  
  ## for proxy objects we set values somewhere and record filename
  f <- tempfile(fileext=".png")
  set_vals(obj, items=f)

  if(dirname != "")
    img <- paste(dirname, filename, sep=.Platform$file.sep)
  else
    img <- filename
  if(file.exists(img))
    .write_image(img, f)

  
  constructor <- "Ext.Component"
  args <- list(html=obj[],
               width=width, height=height)
  
 args <- merge_list(args, ext.args, add_dots(obj, ...))
 push_queue(write_ext_constructor(obj, constructor, args))

  ## add
  add(container, obj, ...)

  obj
  
  
  

}


.write_image <- function(img, file) {
  file.copy(img, file, overwrite=TRUE)

}

set_value_js.GImage <- function(obj, value) {
  if(!file.exists(value))
    return()
  file <- get_items(obj)
  .write_image(value, file)
  call_ext(obj, "update", shQuote(obj[]))
}


## odd method, but whatevs. Might change. Returns url with image
"[.GImage" <- function(obj, ...) {
  ##
  ID <- ..e..$..ID..
  whisker.render("<img src='temp_file?ID={{ID}}&obj={{obj}}'></img>") # url_base?
}
  
