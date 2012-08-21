w <- gwindow("testing")
g <- gvbox(cont=w, use.scrollwindow=TRUE)

ghtml("
The `gpanel` widget allows one to call external JavaScript libraries
for use within this framework. One specifies a character vector of URLs
which are loaded. Afterwards, the user-specified callback (in JavaScript)
is called. If this is omitted, any handlers given through `addHandlerChanged`
are called.

This example uses the d3 library to draw a line and add some text
", markdown=TRUE, cont=g)

pan <- gpanel(cont=g, width=200, height=200)


d3_url <- "http://cdnjs.cloudflare.com/ajax/libs/d3/2.10.0/d3.v2.min.js"

## command to add text. The div_id is selected, then has its html adjusted.
tpl <- "
function(data, status, xhr) {
   d3.select('#{{div_id}}').html('Look ma HTML');
}
"
cmd <- whisker.render(tpl, list(div_id=gpanel_div_id(pan)))

gpanel_load_external(pan, d3_url, cmd)

## no draw a line
tpl2 <- "
function(data, status, xhr) {
var chart = d3.select('#{{div_id}}').append('svg')
    .attr('class', 'chart')
    .attr('width', 200)
    .attr('height', 200);

chart.append('line')
    .attr('x1', 25)
    .attr('x2', 200 - 25)
    .attr('y1', 75)
    .attr('y2', 125)
    .style('stroke', '#000');
}
"
cmd <- whisker.render(tpl2, list(div_id=gpanel_div_id(pan)))
gpanel_load_external(pan, d3_url, cmd)
