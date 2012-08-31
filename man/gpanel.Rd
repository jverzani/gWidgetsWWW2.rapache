\name{gpanel}
\alias{gpanel}
\title{A panel to hold other JavaScript things}
\usage{
  gpanel(container, handler = NULL, action = NULL, ...,
    width = NULL, height = NULL, ext.args = NULL,
    div_id = NULL)
}
\value{
  a \code{GPanel} reference class object
}
\description{
  This produces a widget holding a "div" tag that other
  JavaScript libraries can use to place their content.
  There are a few reference class methods that make this
  possible.  The \code{div_id} method returns the DOM id of
  the div object that is produced. The
  \code{add_handler_onload} method can be used to call a
  handler after the external libraries are loaded. This is
  an asynchronous call, so one need not worry that the
  libraries are done downloading. This call might require
  JavaScript commands to be processed that are not produced
  by a gWidgetsWWW2 handler. The \code{add_js_queue} method
  allows one to push such commands back to the browser. The
  method \code{load_external} is used to load external
  scripts by specifying the appropriate url(s).
}
\examples{
w <- gwindow("windows and dialogs")
g <- ggroup(cont=w, horizontal=FALSE)

pan <- gpanel(cont=g, width=200, height=200)
## will load d3 javascript library
d3_url <- "http://mbostock.github.com/d3/d3.js?2.7.1"
## template to simply insert HTML
## div_id comes from pan$div_id()
tpl <- "
function(data, status, xhr) {
  d3.select('#{{div_id}}').html('Look ma HTML');
}
"
## more complicated example to draw a line
tpl2 <- "
function(data, status, xhr) {
var chart = d3.select('#{{div_id}}').append('svg')
    .attr('class', 'chart')
    .attr('width', 200)
    .attr('height', 200);

chart.append('line')
    .attr('x1', 25)
    .attr('x2', 200 - 25)
    .attr('y1', 100)
    .attr('y2', 100)
    .style('stroke', '#000');
}
"

cmd <- whisker.render(tpl2, list(div_id=pan$div_id()))
pan$load_external(d3_url, cmd)
}

