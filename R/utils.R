
## utils

##' || with NULL
##'
##' @export
"%||%" <- function(a, b) if(missing(a) || is.null(a) || (is.character(a) && nchar(a) == 0) || (length(a) == 1 && is.na(a[1]))) b else a

## merge multiple lists
merge_list <- function(l1, l2, l3, ...) {
  if(missing(l2))
    return(l1)
  for(key in names(l2))
    l1[[key]] <- l2[[key]]
  if(!missing(l3))
    l1 <- merge_list(l1, l3, ...)
  l1
}


## make a list into a JS object
## useful for constructors
list_to_object <- function(x, ...) UseMethod("list_to_object")
list_to_object.default <- function(x, ...) toJSON(x, collapse="")
list_to_object.AsIs <- function(x, ...) x
list_to_object.character <- function(x, ...) {
  if(length(x) == 1) shQuote(x) else NextMethod()
}
list_to_object.numeric <- function(x, ...) {
  if(length(x) == 1) x else NextMethod()
}
list_to_object.logical <- function(x, ...) {
  if(length(x) == 1) tolower(as.character(x)) else NextMethod()
}

list_to_object.list <- function(x) {
  x <- Filter(function(y) !is.null(y), x)
  
  f <- function(nm, value) {
    sprintf("%s: %s", nm, list_to_object(value))
  }
  out <- mapply(f, names(x), x)
  sprintf("{%s}", paste(out, collapse=",\n"))
}


##' Is value a URL: either of our class URL or matches url string: ftp://, http:// or file:///
##'
##' @param x length 1 character value to test
##' @return Logical indicating if a URL.
##' @export
isURL <- function(x) {
  ## we can bypass this by setting a value to have this class
  ## as in isURL((class(x) <- "URL"))
  if(is(x,"URL")) return(TRUE)
  if (is.character(x) && length(x) == 1) 
    out <- length(grep("^(ftp|http|file)://", x)) > 0
 else
   out <- FALSE
  return(out)
}
  

## write constructor
write_ext_constructor <- function(obj, constructor, params="", context) {
  tpl <- '
var ogWidget_{{obj}} = Ext.create({{{constructor}}} {{#params}},{{{params}}}{{/params}});'

  constructor <- shQuote(constructor)
  if(is.list(params))
    params <- list_to_object(params)
  if(missing(context))
    whisker.render(tpl)
  else
    whisker.render(tpl, context)
}

##' call an ext method
##'
##' @obj object
##' @meth method name
##' @params optional parameters. You must format as string
##' @return pushes value to queue, nothing for you to do
##' @export
call_ext <- function(obj, meth, params="") {
  if(is.list(params))
    params <- asJSON(params)
  cmd <- whisker.render("ogWidget_{{{obj}}}.{{meth}}({{{params}}});")
  push_queue(cmd)
}


## return object id
o_id <- function(id) whisker.render("ogWidget_{{id}}")
