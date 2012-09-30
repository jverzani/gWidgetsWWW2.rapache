## Basic stats thing a ding
## Select a data set, then summaries update
## Not great, but shows a way to select variables to modify
## graphic displays.
## Can cause problems if you scroll through selections with key presses too
## fast
require(MASS);

##' a simple summary of a variable, data frame or list
data_descr <- function(x) UseMethod("data_descr")
data_descr.default <- function(x) {
  sprintf("A variable of class %s with %s values", class(x)[1], length(x))
}
data_descr.integer <- function(x) {
  sprintf("An integer variable with %s values from %s to %s",
          length(x), min(x), max(x))
}
data_descr.numeric <- function(x) {
  sprintf("A numeric variable with %s values from %.3f to %.3f",
          length(x), min(x), max(x))
}
data_descr.factor <- function(x) {
  levs <- levels(x)
  if(length(levs) < 6)
     sprintf("A factor with levels %s", paste(levs, collapse=", "))
  else
    sprintf("A factor with levels in %s...", paste(head(levels(x)),collapse=", "))
}
data_descr.data.frame <- function(x) {
  paste(sprintf("A data frame with %s cases and variables:", nrow(x)),
        paste(Map(function(nm, x) paste(nm, data_descr(x), sep=": "),
                  paste("<b>", names(x),"</b>"), x),
              collapse="<br/>&nbsp;"),
        sep="<br/>&nbsp;")
        
}
data_descr.list <- function(x) {
  sprintf("A list with %s components", length(x))
}


##' A variable summary with more detail
data_summary <- function(x) UseMethod("data_summary")
data_summary.default <- function(x) {
  out <- paste(capture.output(summary(x)), collapse="\n")
  tpl <- "
<pre>
 {{{out}}}
</pre>
"
  whisker.render(tpl)
}
data_summary.data.frame <- function(x) {
  out <- mapply(function(nm, var) paste("<h6>", nm, "</h6>", data_summary(var)), names(x), x, SIMPLIFY=FALSE)
  paste(out, collapse="\n")
}


## globals
mydataset <- NULL
datasets <- data()$results ## all datasets

w <- gwindow()
gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)

nb <- gnotebook(cont=w)
g <- gvbox(cont=nb, label="Select a data set")

fl <- gformlayout(cont=g)

data_sel <- gtable(data.frame(Name=datasets[,3], package=datasets[,1], Description=datasets[,4],
                              stringsAsFactors=FALSE),
                   label="Data set", cont=fl, height=400,
                   paging=200, col.widths=c(0,0,1),
                   buffer=200           # not so fast...
                   )
data_descr_label <- ghtml("No data set selected", cont=g)


do_data_summary <- function() {
  if(is.null(mydataset))
    descr <- "No selected data set"
  else
    descr <- data_descr(mydataset)
  svalue(data_descr_label) <- descr
}

addHandlerSelect(data_sel, handler=function(h,...) {
  require(MASS); 
  i <- svalue(h$obj, index=TRUE)
  data(datasets[i,3], package=datasets[i,1])
  mydataset <<- get(gsub("\\s(.*)$", "", datasets[i,3]))
  do_data_summary()
  update_numeric_summary_window(clear=TRUE)
  update_graphical_summary_window(clear=TRUE)
})
  
##################################################
## Numeric summary window
g1 <- gvbox(cont=nb, label="Numeric summaries", use.scrollwindow=TRUE)

## layout
numeric_summary_area <- ghtml("No data selected", cont=g1)


update_numeric_summary_window <- function(clear=FALSE) {

  ## update summary window
  svalue(numeric_summary_area) <- data_summary(mydataset)
}


##################################################
g2 <- ggroup(cont=nb, label="Graphical summaries", use.scrollwindow=TRUE)
## layout
f2 <- gframe("Variables", cont=g2)

empty_DF <- data.frame(icon=asIcon("cancel"),
                       variable="none",
                       stringsAsFactors=FALSE)

var_selector <- gtable(empty_DF,
                       col.widths=c(0,1),
                       width=300,
                       cont=f2,
                       multiple=TRUE
                       )

plot_window <- gcanvas(cont=g2, width=600, height=400)

addHandlerSelect(var_selector, function(h,...) {
  ind <- svalue(h$obj, index=TRUE)
  if(length(ind) == 1) {
    varname <- as.character(h$obj[ind, 2])
    make_plot(mydataset[[varname]], varname)
  } else {
    ind <- ind[1:2]                     # first two!
    make_bi_plot(as.character(h$obj[ind, 2]))
  }
})

empty_plot <- function(...) {
  f <- tempfile()
  canvas(f, width=600, height=400)
  plot.new()
  plot.window(xlim=c(0,1), ylim=c(0,1))
  text(.5, .5, "Select one or two variables to see a graphic")
  dev.off()
  svalue(plot_window) <- f
}


make_plot <- function(x, nm="a variable") {
  f <- tempfile()
  canvas(f, width=600, height=400)
  plot(x, title=sprintf("Plot of %s", nm))
  dev.off()
  svalue(plot_window) <- f
}

make_bi_plot <- function(vars) {
  facts <- Filter(function(i) is.factor(mydataset[[i]]), vars)
  not_facts <- Filter(function(i) !is.factor(mydataset[[i]]), vars)

  f <- tempfile()
  canvas(f, width=600, height=400)
  if(length(facts) == 2) {
    fm <- as.formula(sprintf("~ %s + %s", facts[1], facts[2]))
    mosaicplot(fm, data=mydataset,
           main=sprintf("Mosaic plot of %s by %s", facts[1], facts[2])
           )
  } else if(length(facts) == 1) {
    boxplot(mydataset[[not_facts]] ~ mydataset[[facts]],
             main=sprintf("Boxplot of %s by %s", not_facts, facts)
             )
  } else {
    plot(mydataset[[not_facts[1]]] ~ mydataset[[not_facts[2]]],
         main = sprintf("xyplot of %s by %s", not_facts[1], not_facts[2]),
         xlab=not_facts[2], ylab=not_facts[1])
  }
  dev.off()
  svalue(plot_window) <- f     

}
    


update_graphical_summary_window <- function(clear=FALSE) {
  block_handlers(var_selector); on.exit(unblock_handlers(var_selector))

  if(is.list(mydataset)) {
    DF <- data.frame(icon=asIcon(rep("ok", length(mydataset))),
                     variable=names(mydataset),
                     stringsAsFactors=FALSE)
    enabled(var_selector) <- TRUE
    var_selector[] <- DF
    empty_plot()
  } else {
    enabled(var_selector) <- FALSE
    var_selector[] <- empty_DF
    make_plot(mydataset)
  }

}


##
svalue(nb) <- 1
