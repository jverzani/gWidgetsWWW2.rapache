## Dashboard implementation ala:
## http://stackoverflow.com/questions/12545240/dashboards-dial-meters-in-r

dashboard <- function(dial=list(
                        list(color="red",
                             range=c(10, 40)),
                        list(color="yellow",
                             range=c(40, 60)),
                        list(color="green",
                             range=c(70, 100))
                        ),
                      value=from) {


  from <- min(unlist(lapply(dial, "[[", i="range")))
  to <-  max(unlist(lapply(dial, "[[", i="range")))

  theta <- seq(-pi/3, pi + pi/3, length=100)
  r <- 1
  
  scale <- function(x) {
    m <- (pi + pi/3 - (-pi/3))/(from - to)
    (pi + pi/3) + m*(x - from)
  }

  plot.new()
  plot.window(xlim=c(-1, 1), ylim=c(sin(-pi/3), 1))
  
  lines(cos(theta), sin(theta))
  sapply(dial, function(l) {
    d <- scale(l$range)
    x <- seq(d[1], d[2], length=100)
    lines(cos(x), sin(x), col=l$color, lwd=3)
  })

  ticks <- pretty(c(from, to), n=5)
  ticks_th <- scale(ticks)
  r <- 1 - .15
  text(r*cos(ticks_th), r*sin(ticks_th), labels=ticks)

  sapply(ticks_th, function(th) {
    lines(cos(th)*c(1,.95), sin(th)*c(1, .95))
  })
  
  r <- 1 - .25
  th <- scale(value)
  arrows(0, 0, cos(th), sin(th))

  
}
  
## Now stick in a GUI
## What to measure?

width <- 300; height <- 300


w <- gwindow("Dashboard example")
gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)

g <- gvbox(cont=w)
ghtml("A sample dashboard using `gtimer` to poll periodically for an update.", markdown=TRUE, cont=g)
f <- ggroup(cont=g)
g1 <- gframe("Minutes", cont = f)
g2 <- gframe("Seconds", cont = f)


min_dev <- gcanvas(width=width, height=height, cont=g1)
sec_dev <- gcanvas(width=width, height=height, cont=g2)

update_min <- function(...) {
  m <- as.numeric(format(now(), format="%M"))
  f <- tempfile()
  canvas(f, width=width, height=height)
  dashboard(list(list(color="green",
                      range=c(0,40)),
                 list(color="yellow",
                      range=c(40,50)),
                 list(color="red",
                      range=c(50, 60))),
            value=m)
  dev.off()
  svalue(min_dev) <- f
}
  
update_sec <- function(...) {
  s <- as.numeric(format(now(), format="%S"))
  f <- tempfile()
  canvas(f, width=width, height=height)
  dashboard(list(list(color="blue",
                      range=c(0,40)),
                 list(color="brown",
                      range=c(40,50)),
                 list(color="yellow",
                      range=c(50, 60))),
            value=s)
  dev.off()
  svalue(sec_dev) <- f
}

## initialize
library(lubridate)
update_min()
update_sec()

gtimer(5000, function(...) {
  library(lubridate)
  update_min()
  update_sec()
})
