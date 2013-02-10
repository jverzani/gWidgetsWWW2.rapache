
## utils

##' or with NULL
##'
##' @export
##' @rdname ouror
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
  if(length(x) == 1) shQuote(our_escape(x)) else NextMethod()
}
list_to_object.numeric <- function(x, ...) {
  if(length(x) == 1) x else NextMethod()
}
list_to_object.logical <- function(x, ...) {
  if(length(x) == 1) tolower(as.character(x)) else NextMethod()
}

## use wrap="array" to get [{..},{...}, ...] output
list_to_object.list <- function(x, wrap="object") {
  x <- Filter(function(y) !is.null(y), x)
  
  f <- function(nm, value) {
    sprintf("%s: %s", nm, list_to_object(value))
  }
  out <- mapply(f, names(x), x, SIMPLIFY=FALSE)
  sprintf(ifelse(wrap=="object", "{%s}", "[%s]"), paste(out, collapse=",\n"))
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
##' @param obj object
##' @param meth method name
##' @param params optional parameters. You must format as string
##' @return pushes value to queue, nothing for you to do
##' @export
call_ext <- function(obj, meth, params="") {
  if(is.list(params))
    params <- list_to_object(params)    # was toJSON?
  cmd <- whisker.render("ogWidget_{{{obj}}}.{{meth}}({{{params}}});")
  push_queue(cmd)
}


## return object id
o_id <- function(id) whisker.render("ogWidget_{{id}}")

##' escape slash n
escape_slashn <- function(x) {
  ## from DTL's RJSONIO
  tmp <- gsub('(\\\\)', '\\1\\1', x)
  gsub("\\n", "\\\\n", tmp)
}  

##' escape single quote
##'
##' Useful as we often single quote arguments to the Ext functions
##' @param x string to escape
##' @return string with "'" replaced by "\'"
escape_single_quote <- function(x) {
  gsub("'", "\\\\'", x)
}

escape_double_quote <- function(x) {
  gsub('"', '\\\\"', x)
}

## esacpe " || ' and \n
our_escape <- function(x, type="double") {
  if(type == "single")
    x <- escape_single_quote(x)
  else
    x <- escape_double_quote(x)
  escape_slashn(x)
}

## MIME stuff from Jeffrey Horner's Rook package
MIME_TYPES <- new.env(hash=TRUE)
with(MIME_TYPES,{
  ".3gp"     <- "video/3gpp"
  ".a"       <- "application/octet-stream"
  ".ai"      <- "application/postscript"
  ".aif"     <- "audio/x-aiff"
  ".aiff"    <- "audio/x-aiff"
  ".asc"     <- "application/pgp-signature"
  ".asf"     <- "video/x-ms-asf"
  ".asm"     <- "text/x-asm"
  ".asx"     <- "video/x-ms-asf"
  ".atom"    <- "application/atom+xml"
  ".au"      <- "audio/basic"
  ".avi"     <- "video/x-msvideo"
  ".bat"     <- "application/x-msdownload"
  ".bin"     <- "application/octet-stream"
  ".bmp"     <- "image/bmp"
  ".bz2"     <- "application/x-bzip2"
  ".c"       <- "text/x-c"
  ".cab"     <- "application/vnd.ms-cab-compressed"
  ".cc"      <- "text/x-c"
  ".chm"     <- "application/vnd.ms-htmlhelp"
  ".class"   <- "application/octet-stream"
  ".com"     <- "application/x-msdownload"
  ".conf"    <- "text/plain"
  ".cpp"     <- "text/x-c"
  ".crt"     <- "application/x-x509-ca-cert"
  ".css"     <- "text/css"
  ".csv"     <- "text/csv"
  ".cxx"     <- "text/x-c"
  ".deb"     <- "application/x-debian-package"
  ".der"     <- "application/x-x509-ca-cert"
  ".diff"    <- "text/x-diff"
  ".djv"     <- "image/vnd.djvu"
  ".djvu"    <- "image/vnd.djvu"
  ".dll"     <- "application/x-msdownload"
  ".dmg"     <- "application/octet-stream"
  ".doc"     <- "application/msword"
  ".dot"     <- "application/msword"
  ".dtd"     <- "application/xml-dtd"
  ".dvi"     <- "application/x-dvi"
  ".ear"     <- "application/java-archive"
  ".eml"     <- "message/rfc822"
  ".eps"     <- "application/postscript"
  ".exe"     <- "application/x-msdownload"
  ".f"       <- "text/x-fortran"
  ".f77"     <- "text/x-fortran"
  ".f90"     <- "text/x-fortran"
  ".flv"     <- "video/x-flv"
  ".for"     <- "text/x-fortran"
  ".gem"     <- "application/octet-stream"
  ".gemspec" <- "text/x-script.ruby"
  ".gif"     <- "image/gif"
  ".gz"      <- "application/x-gzip"
  ".h"       <- "text/x-c"
  ".htc"     <- "text/x-component"
  ".hh"      <- "text/x-c"
  ".htm"     <- "text/html"
  ".html"    <- "text/html"
  ".ico"     <- "image/vnd.microsoft.icon"
  ".ics"     <- "text/calendar"
  ".ifb"     <- "text/calendar"
  ".iso"     <- "application/octet-stream"
  ".jar"     <- "application/java-archive"
  ".java"    <- "text/x-java-source"
  ".jnlp"    <- "application/x-java-jnlp-file"
  ".jpeg"    <- "image/jpeg"
  ".jpg"     <- "image/jpeg"
  ".js"      <- "application/javascript"
  ".json"    <- "application/json"
  ".log"     <- "text/plain"
  ".m3u"     <- "audio/x-mpegurl"
  ".m4v"     <- "video/mp4"
  ".man"     <- "text/troff"
  ".manifest"<- "text/cache-manifest"
  ".mathml"  <- "application/mathml+xml"
  ".mbox"    <- "application/mbox"
  ".mdoc"    <- "text/troff"
  ".me"      <- "text/troff"
  ".mid"     <- "audio/midi"
  ".midi"    <- "audio/midi"
  ".mime"    <- "message/rfc822"
  ".mml"     <- "application/mathml+xml"
  ".mng"     <- "video/x-mng"
  ".mov"     <- "video/quicktime"
  ".mp3"     <- "audio/mpeg"
  ".mp4"     <- "video/mp4"
  ".mp4v"    <- "video/mp4"
  ".mpeg"    <- "video/mpeg"
  ".mpg"     <- "video/mpeg"
  ".ms"      <- "text/troff"
  ".msi"     <- "application/x-msdownload"
  ".odp"     <- "application/vnd.oasis.opendocument.presentation"
  ".ods"     <- "application/vnd.oasis.opendocument.spreadsheet"
  ".odt"     <- "application/vnd.oasis.opendocument.text"
  ".ogg"     <- "application/ogg"
  ".ogv"     <- "video/ogg"
  ".p"       <- "text/x-pascal"
  ".pas"     <- "text/x-pascal"
  ".pbm"     <- "image/x-portable-bitmap"
  ".pdf"     <- "application/pdf"
  ".pem"     <- "application/x-x509-ca-cert"
  ".pgm"     <- "image/x-portable-graymap"
  ".pgp"     <- "application/pgp-encrypted"
  ".pkg"     <- "application/octet-stream"
  ".pl"      <- "text/x-script.perl"
  ".pm"      <- "text/x-script.perl-module"
  ".png"     <- "image/png"
  ".pnm"     <- "image/x-portable-anymap"
  ".ppm"     <- "image/x-portable-pixmap"
  ".pps"     <- "application/vnd.ms-powerpoint"
  ".ppt"     <- "application/vnd.ms-powerpoint"
  ".ps"      <- "application/postscript"
  ".psd"     <- "image/vnd.adobe.photoshop"
  ".py"      <- "text/x-script.python"
  ".qt"      <- "video/quicktime"
  ".ra"      <- "audio/x-pn-realaudio"
  ".rake"    <- "text/x-script.ruby"
  ".ram"     <- "audio/x-pn-realaudio"
  ".rar"     <- "application/x-rar-compressed"
  ".rb"      <- "text/x-script.ruby"
  ".rdf"     <- "application/rdf+xml"
  ".roff"    <- "text/troff"
  ".rpm"     <- "application/x-redhat-package-manager"
  ".rss"     <- "application/rss+xml"
  ".rtf"     <- "application/rtf"
  ".ru"      <- "text/x-script.ruby"
  ".s"       <- "text/x-asm"
  ".sgm"     <- "text/sgml"
  ".sgml"    <- "text/sgml"
  ".sh"      <- "application/x-sh"
  ".sig"     <- "application/pgp-signature"
  ".snd"     <- "audio/basic"
  ".so"      <- "application/octet-stream"
  ".svg"     <- "image/svg+xml"
  ".svgz"    <- "image/svg+xml"
  ".swf"     <- "application/x-shockwave-flash"
  ".t"       <- "text/troff"
  ".tar"     <- "application/x-tar"
  ".tbz"     <- "application/x-bzip-compressed-tar"
  ".tcl"     <- "application/x-tcl"
  ".tex"     <- "application/x-tex"
  ".texi"    <- "application/x-texinfo"
  ".texinfo" <- "application/x-texinfo"
  ".text"    <- "text/plain"
  ".tif"     <- "image/tiff"
  ".tiff"    <- "image/tiff"
  ".torrent" <- "application/x-bittorrent"
  ".tr"      <- "text/troff"
  ".txt"     <- "text/plain"
  ".vcf"     <- "text/x-vcard"
  ".vcs"     <- "text/x-vcalendar"
  ".vrml"    <- "model/vrml"
  ".war"     <- "application/java-archive"
  ".wav"     <- "audio/x-wav"
  ".webm"    <- "video/webm"
  ".wma"     <- "audio/x-ms-wma"
  ".wmv"     <- "video/x-ms-wmv"
  ".wmx"     <- "video/x-ms-wmx"
  ".wrl"     <- "model/vrml"
  ".wsdl"    <- "application/wsdl+xml"
  ".xbm"     <- "image/x-xbitmap"
  ".xhtml"   <- "application/xhtml+xml"
  ".xls"     <- "application/vnd.ms-excel"
  ".xml"     <- "application/xml"
  ".xpm"     <- "image/x-xpixmap"
  ".xsl"     <- "application/xml"
  ".xslt"    <- "application/xslt+xml"
  ".yaml"    <- "text/yaml"
  ".yml"     <- "text/yaml"
  ".zip"     <- "application/zip"
})

rook_mime_type <- function(ext=NULL,fallback='application/octet-stream'){
  if (is.null(ext) || !nzchar(ext) || is.null(MIME_TYPES[[ext]]))
    fallback
  else
    MIME_TYPES[[ext]]
}
rook_file_extname <- function(fname=NULL){
  if (is.null(fname))
    base::stop("need an argument of character")
  paste('.',rev(strsplit(fname,'.',fixed=TRUE)[[1]])[1],sep='')
}

get_content_type <- function(f) rook_mime_type(rook_file_extname(basename(f)))



##' Make url with url base appended
##'
##' @param x frament of url
make_url <- function(x) x#sprintf("%s/%s", url_base, x)
