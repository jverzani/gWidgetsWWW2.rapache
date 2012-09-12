## example of gfile
## we use a stack widget with the first card to upload the file, the second
## to show some simple summary.


w <- gwindow("gfile example")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)

sw <- gstackwidget(cont=w)

## page 1
page1 <- gvbox(cont=sw)
ghtml("Upload a csv file to do something", cont=page1)


## gfile has handler to process file. The filename is done returned through [;
## the path to the uploaded file is through svalue.
f <- gfile(text="Choose a csv file...", cont=page1, handler=function(h,...) {
  nm <- h$obj[];
  path <- svalue(h$obj)
  update_page2(nm, path)
})


page2 <- gvbox(cont=sw)
glabel("<h3>Simple summary of uploaded file</h3>", cont=page2)
nm <- glabel("file name", cont=page2)
var_names <- glabel("", cont=page2)

update_page2 <- function(name, path) {
  svalue(nm) <- sprintf("Name of file is %s", name)
  x <- read.csv(path)
  nms <- paste(names(x), collapse="; ")
  svalue(var_names) <- sprintf("Variable names are: %s", nms)
  svalue(sw) <- 2
}

## set to first page
svalue(sw) <- 1
