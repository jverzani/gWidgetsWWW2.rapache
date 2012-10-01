## motion chart
## a not nearly as good "motion" chart, similar in some way
## to that provided by Google and the googleVis package.

## this allows us to put tooltips on the dots
require("RSVGTipsDevice")

## select a data set and time variable and id variable
dataset <- read.csv(system.file("data", "world_bank.csv", package="gWidgetsWWW2.rapache"))[,-1] #drop rowname
dataset <- subset(dataset, !region.value %in% "Aggregates" , select=-country.id)

time_var <- "year"
id_var <- "country.name"

width <- as.integer(600/75); height <- as.integer(480/75)

##################################################
## this doesn't need changing below

ids <- unique(dataset[[id_var]])
facs <- Filter(function(x) is.factor(dataset[[x]]), names(dataset))
nums <- Filter(function(x) is.numeric(dataset[[x]]) && !grepl(time_var, x), names(dataset))



## handler name
make_graphic <- function(h,...) draw_graphic()

## layout
w <- gwindow("Motion chart -- poor man's googleVis")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)


g <- gvbox(cont=w)
ghtml("<h3>A sample 'motion' chart, better implemented in the googleVis package</h3>", cont=g)
g1 <- ggroup(cont=g)


y_gp <- gvbox(cont=g1)
x_gp <- gvbox(cont=g1)
attr_gp <- gvbox(cont=g1)



## y
glabel("y", cont=y_gp)
y_sel <- gcombobox(nums, selected=1, cont=y_gp)
glabel("scale", cont=y_gp)
y_scale <- gcombobox(c("linear", "log"), cont=y_gp)


## x
our_dev <- gsvg(cont=x_gp, width=width*75, height=height*75)

bg <- ggroup(cont=x_gp)
x_sel <- gcombobox(nums, selected=2, cont=bg, expand=TRUE)
x_scale <- gcombobox(c("linear", "log"), cont=bg)

bg <- ggroup(cont=x_gp)
glabel(time_var, cont=bg)
tmp <- dataset[[time_var]]
sl <- gslider(min(tmp), max(tmp), 1, min(tmp), cont=bg, width=width*75)
addHandlerChanged(sl, handler=function(h,...) {
  do_trails <<- TRUE
    make_graphic()
})

## attr
glabel("Color", cont=attr_gp)
col_sel <- gcombobox(facs, cont=attr_gp)

glabel("Size", cont=attr_gp)
size_sel <- gcombobox(nums, selected=3,  cont=attr_gp)

glabel("Labels", cont=attr_gp)
label_sel <- gtable(data.frame("Labels"=ids, stringsAsFactors=FALSE),
                    selection="checkbox",
                    cont=attr_gp,
                    paging=length(ids),
                    width=200,
                    height=400)




## make our graphic
do_trails <- FALSE

draw_graphic <- function() {
  f <- tempfile()
  require(RSVGTipsDevice)
  devSVGTips(f, width=width, height=height, title="Motion chart")
  #svg(f, width=width, height=height)

  ## variable names
  y_var <- svalue(y_sel); x_var <- svalue(x_sel)
  tm <- svalue(sl)

  ## attributes
  col <- svalue(col_sel); sz <- svalue(size_sel); labels <- svalue(label_sel)

  cur_data <- dataset[dataset[[time_var]] == as.numeric(tm),, drop=FALSE]

  ## too slow!
  ## require(ggplot2)
  ## require(ggplot2)
  ## p <- ggplot(cur_data, aes_string(x=x_var, y=y_var))
  ## p <- p + geom_point(aes_string(colour=col, size=sz))
  ## ## geom_text ...

  ## p + theme(legend.position = "none")

  ## print(p)


  fm <- as.formula(sprintf("%s ~ %s", y_var, x_var))
  ## scales
  rainbow_colors <- rainbow(length(levels(cur_data[[col]])))
  cols <- rainbow_colors[cur_data[[col]]]
  if(nchar(sz)) {
    z <- cur_data[[sz]]
    rng <- range(z, na.rm=TRUE)
    cex <- 1 + sqrt((z - rng[1])/diff(rng) * 16)
  } else {
    cex <- 1
  }
  do_log <- paste(ifelse(svalue(x_scale) == "log", "x", ""),
                  ifelse(svalue(y_scale) == "log", "y", ""),
                  sep="")
  
  plot(fm, data=cur_data, col=cols, pch=16, cex=cex, log=do_log)

  for(i in 1:nrow(cur_data)) {
    setSVGShapeToolTip(title=ids[i])
    points(cur_data[i, x_var], cur_data[i, y_var], log=do_log, pch=16,
           col=cols[i], cex=cex[i])
  }
                       
  
  ## add trails for each selected
  sapply(labels, function(val) {
    sub_data <- dataset[as.character(dataset$country.name) == val &
                        dataset$year <= as.numeric(tm),
                        c(x_var, y_var, time_var)]
    sub_data <- sub_data[order(sub_data[[time_var]]), ]
    lines(sub_data[,x_var], sub_data[,y_var], cex=2, log=do_log)
  })
  sapply(labels, function(val) {
    x <- dataset[dataset[[time_var]] == tm & as.character(dataset[[id_var]]) == val,
                 x_var]
    y <- dataset[dataset[[time_var]] == tm & as.character(dataset[[id_var]]) == val,
                 y_var]
    text(x, y, labels=val)
  })

  
  dev.off()
  svalue(our_dev) <- f

}
## initial graphic after a delay
gtimer(1000, make_graphic, one.shot=TRUE)

## add callbacks
for(i in list(y_sel, y_scale,
              x_sel, x_scale,
              col_sel, size_sel))
  addHandlerChanged(i, make_graphic)

addHandlerSelect(label_sel, make_graphic)

