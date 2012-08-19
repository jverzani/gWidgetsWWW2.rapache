w <- gwindow("border layout")
sb <- gstatusbar("Powered by gWidgetsWWW2 and rapache", container=w)

#
bl <- gborderlayout(cont=w,
                    title=list(center="State facts (state.x77)", west="Select a state"),
                    collapsible=list(west=TRUE)
                    )
## when adding to border layout, one specifies the "where" argument with
## one of "center","north", "south", "east", "west"
fr <- gvbox(use.scrollwindow=TRUE, cont=bl, where="west")
tbl <- gradio(state.name, horizontal=FALSE, cont=fr)

## to sepecify the panel size we use this call:
set_panel_size(bl, "west", 200)

## The 4 compass areas are optional, but there must be a child component in
## the "center" area. Here we put a box container.
g <- ggroup(cont=bl, where="center",
            horizontal=FALSE, height=500, width=500)
nms <- colnames(state.x77)

labs <- lapply(seq_along(nms), function(i) {
  g1 <- ggroup(cont=g, width=500)
  glabel(sprintf("<b>%s</b>",nms[i]), cont=g1)
  glabel("", cont=g1)
})
## some stuff
update_state_info=function(h,...) {
#  nm <- svalue(h$obj)
#  nm <- svalue(tbl)
  nm <- 3
  nm <- sample(rownames(state.x77),1)
  facts <- state.x77[nm,]
  sapply(seq_along(facts), function(i) {
    lab <- labs[[i]]
    svalue(lab) <- facts[i]
  })
}
addHandlerChanged(tbl, handler=update_state_info)
