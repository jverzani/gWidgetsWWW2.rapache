require(ggplot2)

w <- gwindow("Various graphics options")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)
g <- gvbox(cont=w, use.scrollwindow=TRUE)

ghtml("This example shows various graphics options: `png`, `canvas`, `svg`, and `d3`", markdown=TRUE, cont=g)

width <- 480; height <- 400

## png
f <- gframe("gimage", cont=g, height =height)

tmp <- tempfile()
png(tmp, width=width, height=height)
print(qplot(mpg, wt, data=mtcars, facets=vs ~ am))
dev.off()
gimage(tmp, cont=f, height=height)





## svg
f <- gframe("gsvg", cont=g, height=height)

tmp <- tempfile()
svg(tmp, width=width/75, height=height/75) # inches, not px
print(qplot(mpg, wt, data=mtcars, facets=vs ~ am))
dev.off()
gsvg(tmp, cont=f, width=width, height=height)


## canvas
f <- gframe("gcanvas -- doesn't like lattice or ggplot, but has event handlers and reloads don't flicker", cont=g, height=height)


tmp <- tempfile(fileext=".js")
canvas(tmp, width=width, height=height)
plot(wt ~ mpg, mtcars)
dev.off()
cnv <- gcanvas(tmp, cont=f, width=width, height=height)
addHandlerClicked(cnv, handler=function(h,...) {
  galert(paste(capture.output(print(h)), collapse="\n"))
})

## cheap use of d3.
f <- gframe("d3 (for the intrepid) From http://www.jasondavies.com/animated-bezier/", cont=g, height=height)
pan <- gpanel(cont=f, div_id="vis", height=height)

d3_url <- "http://cdnjs.cloudflare.com/ajax/libs/d3/2.10.0/d3.v2.min.js"
vis_url <- "http://www.jasondavies.com/animated-bezier/animated-bezier.js"
addHandlerChanged(pan, handler=function(...) galert("all loaded"))
gpanel_load_external(pan, c(d3_url, vis_url))
