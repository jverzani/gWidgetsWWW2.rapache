## http://rstudio.org/docs/advanced/manipulate
## example from tkdensity.R


## This is an example of the manipulate function
## that is provided in RStudio. Here we implement our
## own version using the code from this package. The
## basics are read in here. We need local=TRUE 
source(system.file("demo", "manipulate.R", package="gWidgetsWWW2.rapache"), local=TRUE)

## this is an example usage. The idea comes from the tkdensity.R demo
## in the tcltk package.

w <- gwindow("Manipulate example")
gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)

manipulate(
           {
             y <- get(distribution)(size)
             plot(density(y, bw=bandwidth, kernel=kernel))
             points(y, rep(0, size))
           },
           ##
           distribution=picker("Normal"="rnorm", "Exponential"="rexp"),
           kernel=picker("gaussian", "epanechnikov", "rectangular",
             "triangular", "cosine"),
           size=picker(5, 50, 100, 200, 300),
           bandwidth=slider(0.05, 2.00, step=0.05, initial=1),
           button=button("Refresh"),
           ##
           container=w,       
           device="svg",                # svg or canvas or png
           delay=1000                   # delay to let data load for comboboxes
           )
