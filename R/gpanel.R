##' @include gcomponent.R
NULL


##' A panel to hold other JavaScript things
##'
##' This produces a widget holding a "div" tag that other JavaScript
##' libraries can use to place their content. There are a few
##' reference class methods that make this possible.  The
##' \code{div_id} method returns the DOM id of the div object that is
##' produced. The \code{add_handler_onload} method can be used to call
##' a handler after the external libraries are loaded. This is an
##' asynchronous call, so one need not worry that the libraries are
##' done downloading. This call might require JavaScript commands to
##' be processed that are not produced by a gWidgetsWWW2 handler. The
##' \code{add_js_queue} method allows one to push such commands back to
##' the browser. The method \code{load_external} is used to load
##' external scripts by specifying the appropriate url(s).
##' @inheritParams gwidget
##' @return a \code{GPanel} reference class  object
##' @export
##' @examples
##' w <- gwindow("windows and dialogs")
##' g <- ggroup(cont=w, horizontal=FALSE)
##' 
##' pan <- gpanel(cont=g, width=200, height=200)
##' ## will load d3 javascript library
##' d3_url <- "http://mbostock.github.com/d3/d3.js?2.7.1"
##' ## template to simply insert HTML
##' ## div_id comes from pan$div_id()
##' tpl <- "
##' function(data, status, xhr) {
##'   d3.select('#{{div_id}}').html('Look ma HTML');
##' }
##' "
##' ## more complicated example to draw a line
##' tpl2 <- "
##' function(data, status, xhr) {
##' var chart = d3.select('#{{div_id}}').append('svg')
##'     .attr('class', 'chart')
##'     .attr('width', 200)
##'     .attr('height', 200);
##' 
##' chart.append('line')
##'     .attr('x1', 25)
##'     .attr('x2', 200 - 25)
##'     .attr('y1', 100)
##'     .attr('y2', 100)
##'     .style('stroke', '#000');
##' }
##' "
##' 
##' cmd <- whisker.render(tpl2, list(div_id=pan$div_id()))
##' pan$load_external(d3_url, cmd)

gpanel <- function(
                   container,
                   handler=NULL,
                   action=NULL,
                   ...,
                   width=NULL,
                   height=NULL,
                   ext.args = NULL
                   ){

  obj <- new_item()
  class(obj) <- c("GPanel", "GWidget", "GComponent", class(obj))


   ## js
  constructor <- "Ext.Panel"
  args <- list(border = FALSE,
               hideBorders = FALSE,
               width=width,
               height=height,
               html=sprintf("<div id='%s'></div>", gpanel_div_id(obj))
               )
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  ## add
  add(container, obj, ...)

  if(!is.null(handler))
    addHandlerChanged(obj, handler, action, ...)
  
  obj

}


gpanel_div_id <- function(obj) {
  sprintf("ogWidget_%s_div", obj)
}

##' Load urls then run callback
##'
##' @param obj gpanel object
##' @param url vector of urls to load
##' @param callback if specified, a javascript callback. Otherwise,
##' calls any handlers specified through \code{addHandlerChanged}
gpanel_load_external <- function(obj, url, callback) {
   "Url is url of external script(s). To call a handler after the scripts are loaded, use add_handler_onload to add handlers or pass in JavaScript funtion to callback argument"

                           if(missing(callback))
                             callback <- whisker.render("
function(data, textStatus, jqXHR) {
  call_r_handler('{{id}}', 'onload');
}
", list(id=get_id()))
                           
                           ajax_tpl <- "
$.ajax('{{url}}',{
    dataType: 'script',
    type:'GET',
    cache: true,
    success: {{fn}}
});
"

                           fn_template <- "
function(data, textStatus, jqXHR) {
  {{fn}}
}
"

                           ## work back to front
                           url <- rev(url)
                           out <- whisker.render(ajax_tpl, list(url=url[1],
                                                                fn=callback))
                           sapply(url[-1], function(i) {
                             assign("out", whisker.render(ajax_tpl,
                                                          list(url=i,
                                                               fn=whisker.render(fn_template,
                                                                 list(fn=out)))),
                                    inherits=TRUE)
                           })
                           
   push_queue(out)
   
}


addHandlerChanged.GPanel <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "onload", handler, action)
}
