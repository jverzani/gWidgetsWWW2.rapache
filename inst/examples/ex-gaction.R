## An example of actions
## gWidgets uses actions for menubars and buttons
## this shows how actions can be enabled/disabled

w <- gwindow("Example of gaction objects")
gstatusbar("Powered by gWidgetsWWW.rapache and rapache", cont = w)

g <- ggroup(cont=w, horizontal=FALSE)
l <- glabel("An example of how to manipulate actions", cont=g)

handler <- function(h,...) gmessage("called handler", parent=w)

## list of actions.
## actions need the parent argument in gWidgetsWWW2, this i
## optinoal in gWidgetsWWW2.rapache
alist <- list(
  new = gaction(label="new",icon="new",handler = handler, parent = w),
  open = gaction(label="open",icon="modify",handler = handler, parent = w),
  save = gaction(label="save",icon="save",handler = handler, parent = w),
  save.as = gaction(label="save as...",icon="save",handler = handler, parent = w),
  quit = gaction(label="quit",icon="cancel",handler = handler, parent = w),
  cut = gaction(label="cut",icon="cut",handler = handler, parent = w),
  ok = gaction(label="ok", icon="ok", handler=handler, parent=w)
  )

## menu bar list. A nested list. The names of top-level components
## give the menu names
mlist <- list(file = list(
                new = alist$new,
                open = alist$open,
                save = alist$save,
                "save as..." = alist$save.as,
                quit = alist$quit
                ),
              edit = list(
                cut = alist$cut
                )
              )

mb <- gmenu(mlist, cont=w)

l <- glabel("Buttons can take actions toog!).", cont=g)
button_group <- ggroup(cont=g)

b <- gbutton(action = alist$ok, cont = button_group)
gseparator(cont=g)
b1 <- gbutton("set actions as if a 'no changes yet' state", cont=button_group,
              handler = function(h,...) {
                nms <- names(alist)
                grayThese <- c("save","save.as","cut")
                for(i in grayThese)
                  enabled(alist[[i]]) <- FALSE
                for(i in setdiff(nms, grayThese))
                  enabled(alist[[i]]) <- TRUE
              })

b2 <- gbutton("set actions as if 'some change' is the  state", cont=button_group,
              handler = function(h,...) {
                nms <- names(alist)
                grayThese <- c()
                for(i in grayThese)
                  enabled(alist[[i]]) <- FALSE
                for(i in setdiff(nms, grayThese))
                  enabled(alist[[i]]) <- TRUE
              })


