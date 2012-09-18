##' @include gcomponent.R
##' @include utils.R
NULL

##' ghtml
##'
##' @param x text
##' @param markdown if TRUE run through markdownToHTML first
##' @export
ghtml <- function(x, markdown=FALSE, container, ...,
                  width=NULL, height=NULL, ext.args=list()
                  ) {


  obj <- new_item()
  class(obj) <- c("GHtml", "GWidgetTextProxy", "GWidgetProxy", "GWidget", "GComponent", class(obj))
 
 ## for proxy objects we set values somewhere and record filename
  f <- tempfile(fileext=".html")
  set_vals(obj, items=f, properties=list(markdown=markdown))

  if(markdown)
    x <- markdownToHTML(text=x, fragment=TRUE)
  
 .write_file_ghtml(x, f) 
 
 
 ## js
  constructor <- "Ext.Component"
 args <- list(loader=list(url=make_url("proxy_call_text"), ##"/custom/gw/proxy_call_text",
                  autoLoad=TRUE,
                  params=list(ID=I("ID"), obj=as.character(obj)),
                bodyPadding=5,
                width=width,
                height=height
                  )
                )

 args <- merge_list(args, ext.args, add_dots(obj, ...))
 push_queue(write_ext_constructor(obj, constructor, args))

 ## add
 add(container, obj, ...)

 return(obj)

}

##' assignment method for svalue
##' @method svalue<- GWidgetTextProxy
##' @S3method svalue<- GWidgetTextProxy
##' @rdname svalue_assign
"svalue<-.GWidgetTextProxy" <- function(obj, ..., value) {
  f <- get_vals(obj, "items")
  if(get_vals(obj, "properties")$markdown)
    value <- markdownToHTML(text=value, fragment=TRUE)
  .write_file_ghtml(value, f)
 
  oid <- o_id(obj)
  push_queue(whisker.render("{{oid}}.getLoader().load();"))

  obj
}

set_value_js.GWidgetTextProxy <- function(obj, value) {}

## helper
.write_file_ghtml <- function(x, f) {
  if(isURL(x) ||
     is(x[1], "StaticTempFile") ||
     file.exists(x[1])) {
    x <- paste(readLines(x, warn=FALSE), collapse="\n")
  }
  cat(x, file=f)
}
