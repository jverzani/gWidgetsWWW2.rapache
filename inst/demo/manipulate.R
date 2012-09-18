## http://rstudio.org/docs/advanced/manipulate

## Manipulate example
## we have 4 helpers and main manipulate function


## helper
picker <- function(..., label=NULL) {
  items <- list(...)
  if(!is.null(names(items)))
    items <- data.frame(value=unlist(items), label=names(items), stringsAsFactors=FALSE)
  else
    items <- unlist(items)
  list(FUN="gcombobox", items=items, selected=1, label=label)
}

slider <- function(min, max, initial=min, step=NULL, ..., label=NULL)
  list(FUN="gslider",from=min, to=max, by=step, value=initial, width=250, label=label)

checkbox <- function(initial=FALSE,  label=NULL, ...)
  list(FUN="gcheckbox", checked=initial, label=label)

button <- function(label)
  list(FUN="gbutton", text=label)


## main function
manipulate <- function(.expr, ...,
                       container=gwindow("Manipulate"),
                       device=c("canvas", "png", "svg"),
                       dev.width=480, dev.height=480,
                       delay=500        # ms delay before drawing graphic
                       ) {
  
  expr <- substitute(.expr)

  l <- list(...)
  pg <- gborderlayout(container=container, default.size=300)

  device <- match.arg(device)
  if(device == "canvas") {
    img <- gcanvas( container=pg, where="center", expand=TRUE,
                  width=dev.width,
                  height=dev.height
                  )
  } else if(device == "png") {
    img <- gimage( container=pg, where="center", expand=TRUE,
                  width=dev.width,
                  height=dev.height
                  )
  } else if(device == "svg") {
    img <- gsvg( container=pg, where="center", expand=TRUE,
                  width=dev.width,
                  height=dev.height
                  )
  }
  g <- gvbox(container=pg, where="west")
  flyt <- gformlayout(container=g, align="right", label.width=50)
  
  update_expr <- function(...) {
    ext <- switch(device, "canvas"=".js", "png"=".png", "svg"=".svg")
    tmp <- tempfile(fileext=ext)

    if(device == "canvas") {
      canvas(tmp, width=dev.width, height=dev.height)
    } else if(device == "png") {
      png(tmp, width=dev.width, height=dev.height)
    } else if(device == "svg") {
      svg(tmp, width=as.integer(dev.width/75), height=as.integer(dev.height/75))
    }


    ## must export svalue to use sapply!
    values <- list()
    for(i in names(widgets))
      values[[i]] <- svalue(widgets[[i]])

    
    result <- withVisible(eval(expr, envir=values))
    dev.off()
    svalue(img) <- tmp
  }
  
  make_widget <- function(nm, lst) {
    ## common arguments for all widgets:
    lst$handler <- update_expr
    if(is.null(lst$label))
      lst$label <- nm
    lst$container <- flyt
    do.call(lst$FUN, lst[-1])
  }

  widgets <- mapply(make_widget, names(l), l, SIMPLIFY=FALSE)
  addSpring(g)                          # nicer layout

  gtimer(delay, function(...) {update_expr()}, one.shot=TRUE)                         # initial graphic
  invisible(widgets)
}
