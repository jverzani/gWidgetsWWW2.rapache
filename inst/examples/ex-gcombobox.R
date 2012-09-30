w <- gwindow("combobox exmaple")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)

g <- gvbox(cont=w)
g1 <- gframe("different items", cont=g)
fl <- gformlayout(cont=g1)


items <- data.frame(value=state.name,
                    label=toupper(state.name),
                    icon=rep("help", 50),
                    tooltip=state.name,
                    custom=sprintf("I live in %s", state.name),
                    stringsAsFators=FALSE)

cb <- list()
cb[[1]] <- gcombobox(items[,1, drop=TRUE], label="vector", cont=fl)
cb[[2]] <- gcombobox(items[,1:2], label="value, label", cont=fl)
cb[[3]] <- gcombobox(items[,1:3], label="value, label, icon", cont=fl)
cb[[4]] <- gcombobox(items, label="full monty", cont=fl)
cb[[5]] <- gcombobox(items, label="custom", cont=fl, tpl="<b>{custom}</b>")

## add button to display values
g2 <- gvbox(cont=g1)
b <- gbutton("click me", cont=g2, handler=function(h,...) {
  w1 <- gwindow("values", parent=w)
  g <- gvbox(cont=w1)
  sapply(cb, function(i) glabel(svalue(i), cont=g))
  gbutton("dispose", cont=g, handler=function(h,...) {
    dispose(w1)
  })
})
         
                    
