w <- gwindow("Basic widgets")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)

show_value <- function(h,...) {
  galert(svalue(h$action))
}


g <- gvbox(cont=w, use.scrollwindow=TRUE)
glabel("Widgets for selecting from a set of items", cont=g)

## checkbox
fr <- gframe("gcheckbox", cont=g, horizontal=FALSE)
check_widget <- gcheckbox("Some label", cont=fr)
bg <- ggroup(cont=fr)
gbutton("svalue", cont=bg, handler=show_value, action=check_widget)
gbutton("svalue<-", cont=bg, handler=function(h, ...) {
  svalue(check_widget) <- !svalue(check_widget) ## toggle
})


## gradio
fr <- gframe("gradio", cont=g, horizontal=FALSE)
radio_widget <- gradio(state.name[1:3], selected=2, cont=fr)
bg <- ggroup(cont=fr)
gbutton("svalue", cont=bg, handler=show_value, action=radio_widget)
gbutton("svalue, index=TRUE", cont=bg, handler=function(...) {
  galert(svalue(radio_widget, index=TRUE))
})
gbutton("svalue<-", cont=bg, handler=function(h, ...) {
  svalue(radio_widget) <- state.name[3]
})
gbutton("svalue<-, index=TRUE", cont=bg, handler=function(h, ...) {
  svalue(radio_widget, index=TRUE) <- 1
})






## gcheckboxgroup
fr <- gframe("gcheckboxbroup", cont=g, horizontal=FALSE)
checkgroup_widget <- gcheckboxgroup(state.name[1:3], cont=fr)
bg <- ggroup(cont=fr)
gbutton("svalue", cont=bg, handler=show_value, action=checkgroup_widget)
gbutton("svalue, index=TRUE", cont=bg, handler=function(...) {
  galert(svalue(checkgroup_widget, index=TRUE))
})
gbutton("svalue<-", cont=bg, handler=function(h, ...) {
  svalue(checkgroup_widget) <- state.name[2:3]
})
gbutton("svalue<-, index=TRUE", cont=bg, handler=function(h, ...) {
  svalue(checkgroup_widget, index=TRUE) <- 1:2
})




## gcombobox
fr <- gframe("gcombobox", cont=g, horizontal=FALSE)
combo_widget <- gcombobox(state.name, cont=fr)
bg <- ggroup(cont=fr)
gbutton("svalue", cont=bg, handler=show_value, action=combo_widget)
gbutton("svalue, index=TRUE", cont=bg, handler=function(...) {
  galert(svalue(combo_widget, index=TRUE))
})
gbutton("svalue<-", cont=bg, handler=function(h, ...) {
  svalue(combo_widget) <- state.name[17]
})
gbutton("svalue<-, index=TRUE", cont=bg, handler=function(h, ...) {
  svalue(combo_widget, index=TRUE) <- 3
})



## gtable with checkbox
fr <- gframe("gtable, selection='checkbox'", cont=g, horizontal=FALSE)
items <- data.frame(States=state.name, stringsAsFactors=FALSE)
message("items", dim(items))
table_widget <- gtable(items, selection="checkbox", cont=fr, height=300)
bg <- ggroup(cont=fr)
gbutton("svalue", cont=bg, handler=show_value, action=table_widget)
gbutton("svalue, index=TRUE", cont=bg, handler=function(...) {
  galert(svalue(table_widget, index=TRUE))
})
gbutton("svalue<-", cont=bg, handler=function(h, ...) {
  svalue(table_widget) <- state.name[17]
})
gbutton("svalue<-, index=TRUE", cont=bg, handler=function(h, ...) {
  svalue(table_widget, index=TRUE) <- 3
})



## gslider
fr <- gframe("gslider", cont=g, horizontal=FALSE)
slider_widget <- gslider(from=0, to=100, by=1, value=50, cont=fr)
glabel("Step size must be 1 or more!", cont=fr)
bg <- ggroup(cont=fr)
gbutton("svalue", cont=bg, handler=show_value, action=slider_widget)
gbutton("svalue<-", cont=bg, handler=function(h, ...) {
  svalue(slider_widget) <- 10
})




## gspinbutton
fr <- gframe("gspinbutton", cont=g, horizontal=FALSE)
spin_widget <- gspinbutton(from=0, to=100, by=1, value=50, cont=fr)
bg <- ggroup(cont=fr)
gbutton("svalue", cont=bg, handler=show_value, action=spin_widget)
gbutton("svalue<-", cont=bg, handler=function(h, ...) {
  svalue(spin_widget) <- 10
})


