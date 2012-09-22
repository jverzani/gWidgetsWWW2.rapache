## About gWidgetsWWW2.rapche
##

### This sets up the page
scale <-1 #0.75
page_height <- as.integer(600*scale)

fig_height <- as.integer(500*scale)
fig_width <- as.integer(750*scale)

subw_height <- as.integer(500*scale)
subw_width <- as.integer(700*scale)

def_sidewidth <- as.integer(300*scale)

buttons <- NULL

require(markdown)

## map pages
## use structure of pages list below
map_page <- function(i, lst) {
  b <- gbutton(lst$name, container=button_gp, handler=function(h,...) {
    set_page(h$action)
  }, action=i)


  
  content <- lst$content

  if(is.character(content)) {
    ## markup code
    if(lst$type == "markdown")
      ghtml(markdownToHTML(text=content), container=sw, expand=TRUE)
    else if(lst$type == "pre")
      ghtml(sprintf("<pre>%s</pre>", content), container=sw, expand=TRUE)
    else if(lst$type == "code")
      ghtml(sprintf("<code><pre>%s</pre></code>", content), container=sw, expand=TRUE)
    else if(lst$type == "html")
      ghtml(content, container=sw, expand=TRUE)
    
  } else if(is.function(content)) {
    content(sw)
  }
  the_page <<- i
  b
}

## Basic layout has button prev, next controls
w <- gwindow("About gWidgetsWWW2.rpache")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", container=w)
glabel(" ", cont=sb, expand=TRUE)
dog_food <- gbutton("Source...", container=sb, handler=function(h,...) {
  f <- system.file("examples", "about.R", package="gWidgetsWWW2.rapache")
  subwindow <- gwindow("Source", parent=w,
                       width=subw_width,
                       height=subw_height)
  vb <- gvbox(container=subwindow)
  gtext(paste(gsub("'", "`", readLines(f)), collapse="\n"),
        container=vb)
  gseparator(container=vb)
  bg <- ggroup(container=vb)
  addSpring(bg)
  gbutton("dismiss", container=bg, handler=function(h,...) {
    dispose(subwindow)
  })
})


pg <- gborderlayout(cont=w)

g <- ggroup(cont=pg, where="center", horizontal=FALSE)

bg <- ggroup(cont=g)

ghtml("<img src='http://developer.r-project.org/Logo/Rlogo-5.png' height=24/>&nbsp;<b>gWidgetsWWW2.rapache</b>", cont=bg)

addSpring(bg)
page_title <- ghtml("<h3></h3>", container=bg)
addSpring(bg)


prev_action <- gaction("<", key.accel="LEFT", parent=w, handler=function(h,...) {
  ind <- max(1, the_page - 1)
  set_page(ind)
})
prev_btn <- gbutton(action=prev_action, container=bg)

next_action <- gaction(">", key.accel="RIGHT", parent=w, handler=function(h,...) {
  ind <- min(length(sw), the_page + 1)
  set_page(ind)
})
next_btn <- gbutton(action=next_action, container=bg)
## helper to set the page and update title
set_page <- function(i) {
  svalue(sw) <- i

  ## bold, unbold
  new <- buttons[[i]]; old <- buttons[[the_page]]
  svalue(new) <- sprintf("<b>%s</b>", svalue(new))
  svalue(old) <- gsub("<[^>]*>","", svalue(old))

  
  the_page <<- i
  txt <- pages[[i]]$title
  if(is.null(txt))
    txt <- pages[[i]]$name
  svalue(page_title) <- sprintf("<h3>%s</h3>", txt)
}



## Main container
sw <- gstackwidget(cont=g, expand=TRUE, fill=TRUE)

## gropu to hold buttons
button_gp <- gvbox(cont=pg, where="east", use.scrollwindow=TRUE)
set_panel_size(pg, "east", 200)



##################################################
## make the pages

## globals
the_page <- 0
pages <- list()
add_page <- function(l) pages[[length(pages) + 1]] <<- l

### An intro page

add_page(list(name="Intro",
              title="What is gWidgetsWWW2?",
              content=function(container) {
                intro <- "

Creating interactive web pages within R: gWidgetsWWW2.rapache
-----------------------------------------------------------------------------

```
The gWidgets package implements an easy-to-learn interface for
programming graphical user interfaces within R. It aims to support
tcltk, RGtk2 and qtbase.

The gWidgetsWWW2.rapache package implements _most_ of the gWidgets
interface, allowing users to quickly make interactive web pages within
R, using web technologies, in lieu of a graphical toolkit. The
rapache module allows deployment to a wider audience than the
gWidgetsWWW2 package.
```
"
                
               
                ghtml(intro, markdown=TRUE, container=container)



              }))

## another page


add_page(list(name="Installation",
              title="Installation",
              content=function(container) {
                intro <- "
Installing the package requires:

1) installing `rapache`

2) installing this package from github in a place the rapache process can see.

3) modifying the apache configuration. A minimal example would be:
<pre>
LoadModule R_module /usr/libexec/apache2/mod_R.so ## for rapache
##
RSourceOnStartup('system.file('rapache', startup.R', package='gWidgetsWWW2.rapache')')
## override to look in more places than default
REvalOnStartup \"options('gWidgetsWWW2.rapach`ue::script_base'=c(system.file('examples', package='gWidgetsWWW2.rapache'), '/tmp/','/var/www/gw_scripts'))\"
&lt;Location /gw&gt;
        SetHandler r-handler
        ## from system.file('rapache', 'www2.R', package='gWidgetsWWW2.rapache')
	RFileHandler /Library/Frameworks/R.framework/Versions/2.15/Resources/library/gWidgetsWWW2.rapache/rapache/www2.R
&lt;/Location&gt;
</pre>

4) put a script in a location to be found,
"
                
                
                ghtml(intro, markdown=TRUE, container=container)



              }))




add_page(list(name="Hello world",
              title="Hello world",
              content=function(container) {
                vb <- gvbox(container)
                ghtml("
The basic hello world script below shows several things:
<ul>
<li> - a parent window mapping to the web page
<li> - a container (`ggroup`)
<li> - a component (`gbutton`)
<li> - interactivity added via  `addHandlerChanged`, in this case calling a dialog
</ul>
<pre>
w <- gwindow('Hello world title')
g <- gvbox(cont=w)
b <- gbutton('Click me world', cont=g)
addHandlerChanged(b, function(h,...) {
  galert('Hello world!')
})
</pre>
",  cont=vb)

                gseparator(cont=vb)
                g <- gvbox(cont=vb)
                b <- gbutton('Click me world', cont=g)
                addHandlerChanged(b, function(h,...) {
                  galert('Hello world!')
                })
                
                
              }))


##################################################
nm <- "huh?"
add_page(list(name=nm,
              title=nm,
              content=function(container) {
                vb <- gvbox(container,expand=TRUE, use.scrollwindow=FALSE)
                ghtml("
The basic idea consists of:

A `gwindow` instance maps to a web page
---------------------------------------

These pages are interactive, they are not really well suited for simple display of data. For that, use a templating system (such as `whisker` or `brew`). Note, as with this demo, a page can include multiple windows. However, it is important to know that the pages and data are transient, so one must store the data programmatically if desired.

The look of the page is determined by the JavaScript library extjs
--------------------------------------------------------------------

So you are kinda stuck with it. Not the worst thing in the world. Go to <a href='sencha.com'>sencha.com</a> for details.

The components of the page are laid out within containers
----------------------------------------------------------

There are a handful of container objects whose job is to specify the
layout of components. The components are what you interact with or
have data displayed through.

One calls back into an R process via handlers.
---------------------------------------------------------------------------------

These specified through `addHandlerXXX` functions. The handlers make a
page dynamic. The handlers use R to specify what is to happen
next. This could be modification of the page, or display of additional
data

This is all specified in a script file that is mapped to a URL via `rapache`
-------------------------------------------

So a simple R script becomes an interactive web page, provided you can
configure `rapache` to serve it.

", markdown=TRUE,  height="100%", cont=vb)

                ## other
              }))

##################################################
nm <- "Containers"
add_page(list(name=nm,
              title=nm,
              content=function(container) {
                vb <- gvbox(container)
                ghtml("
There are handful of basic containers: box gcontainers (`ggroup`, `gvbox`, `gframe` and `gexpandgroup`); card containers (`gnotebook` and `gstackwidget`); table layout (`gformlayout`, but not `glayout`); and the flexible `gborderlayout` for laying out in the 5 compass areas.
", markdown=TRUE,  cont=vb)

                g <- gframe("A framed container", cont=vb, horizontal=FALSE)


                
                glabel("this is ", cont=g)
                gbutton("A vertical container", cont=g)
                glabel("inside a vertical frame", cont=g)

                expg <- gexpandgroup("Click me", cont=g)
                glabel("Click the trigger to toggle", cont=expg)

                nb <- gnotebook(cont=g)
                glabel("A notebook page", label="page 1", cont=nb)
                glabel("A second notebook page", label="page 2", cont=nb)
                glabel("A stack widget is a notebook without the tabs", label="tab 3", cont=nb)

                fl <- gformlayout(cont=nb, label="gformlayout")
                gedit("", placeholder="edit widget inside gformlayou", cont=fl, label="edit")
                gcombobox(state.name, cont=fl, label="combobox")
                
                
                ## other
              }))


##################################################
nm <- "Components, basic"
add_page(list(name=nm,
              title=nm,
              content=function(container) {
                vb <- gvbox(container)
                ghtml("
There are a number of basic components provided in `gWidgetsWWW2.rapache`. Here is a smple of some.
", markdown=TRUE,  cont=vb)

                gseparator(cont=vb)
                glabel("glabel", cont=vb)
                gbutton("gbutton", cont=vb)
                fl <- gformlayout(cont=vb)
                gedit("", placeholder="single line text", label="gedit", cont=fl)
                gtext("multi-line\ntext", label="gtext", cont=fl, width=400)
                gslider(from=0, to=100, by=1, label="gslider", cont=fl, width=250)
                gspinbutton(label="gspinbox", cont=fl)
                
                ## other
              }))


##################################################
nm <- "Selection components"
add_page(list(name=nm,
              title=nm,
              content=function(container) {
                vb <- gvbox(container, use.scrollwindow=FALSE)
                ghtml("
There a numerous widgets where the user can select one or more values from a list of items. In `gWidgets` the items to select are referenced through `[`, `svalue` refers to the selection, as appropriate. The argument `index` can be used to specify if the selected index -- or selected value -- is returned.
", markdown=TRUE,  cont=vb)
                fl <- gformlayout(cont=vb)
                gcheckbox("Selected?", checked=TRUE, label="gcheckbox", cont=fl)
                gradio(state.name[1:4], label="gradio", horizontal=FALSE, cont=fl)
                gcheckboxgroup(state.name[1:4], label="gcheckboxgroup", horizontal=FALSE, cont=fl)
                gcombobox(state.name, label="gcombobox", cont=fl)
                m <- data.frame(States=state.name[1:4])
                f <- gframe("gtable", cont=vb)
                gtable(m, label="gtable", cont=f)
                f <- gframe("gtable -- selection='checkbox'", cont=vb)
                gtable(m, label="gtable", selection="checkbox", cont=f)

                ## other
              }))


##################################################
nm <- "methods"
add_page(list(name=nm,
              title=nm,
              content=function(container) {
                vb <- gvbox(cont=container)
                ghtml("
There are a few basic methods: `svalue`, `[`, `visible`, `enabled`, `focus`, etc.
", markdown=TRUE,  cont=vb)

                b <- gbutton("do with me what you will", cont=vb, handler=function(...) galert("ouch"))

                g <- gframe("svalue gives the primary value", cont=vb)
                gbutton("svalue", cont=g, handler=function(h,...) galert(svalue(b)))
                gbutton("svalue<-", cont=g, handler=function(...) svalue(b) <- "a new message")
                g <- gframe("enabled adjusts if widget is sensitive to input", cont=vb)
                
                gbutton("enabled=TRUE", cont=g, handler=function(h,...) enabled(b) <- TRUE)
                gbutton("enabled=FALSE", cont=g, handler=function(h,...) enabled(b) <- FALSE)
                
                g <- gframe("visible depends on widget. Here adjusting if widget is shown or not.", cont=vb)
                gbutton("visible=TRUE", cont=g, handler=function(h,...) visible(b) <- TRUE)
                gbutton("visible=FALSE", cont=g, handler=function(h,...) visible(b) <- FALSE)


                ## other
                g <- gframe("set tooltip", cont=vb)
                gbutton("tooltip<-", cont=g, handler=function(h,...) tooltip(b) <- "Okay, quit hovering over me")
              }))


##################################################
nm <- "Handlers"
add_page(list(name=nm,
              title=nm,
              content=function(container) {
                vb <- gvbox(container)
                ghtml("
Handlers are used by `gWidgetsWWW2.rapache` to callback into the R
process from the web page. A handler is simply an R function with a
first argument that takes a list.

<br/>
A technical point needs to be
made. R functions have environments. To share these among many
different processes (that are started by rapache) an environment is
serialized. Two points:
<br/>

1) don't use reference classes, as they don't serialize well in that
they become large objects -- and larger means slower and less
responsive pages.
<br/>
2) you may need to reload packages within the handler, unless they are
loaded by rapache (and not the script).
<br/>

In practice it can take between 50 and 100ms to process a handler. A
such, we callback to the server as infrequently as possible and still
maintain state server side.

", markdown=TRUE,  cont=vb)

                bg <- ggroup(cont=vb)
                btn <- gbutton("Click me", cont=bg, handler=function(h,...) {
                  galert("Thanks. I needed that.")
                })
                gbutton("block handlers", cont=bg, handler=function(h,...) {
                  block_handlers(btn)
                })
                gbutton("unblock handlers", cont=bg, handler=function(h,...) {
                  unblock_handlers(btn)
                })
                

                ## other
              }))


##################################################
nm <- "dialogs"
add_page(list(name=nm,
              title=nm,
              content=function(container) {
                vb <- gvbox(container)
                ghtml("
There are a few basic dialogs available:
<ul>
<li> - `galert` for quick, transient messsages
<li> - `gmessage` for a modal-like message
<li> - `gconfirm` to confirm an action
<li> - `ginput` to gather textual input
<li> - `gbasicdialog` to help make a subwindow
</ul>
", markdown=TRUE,  cont=vb)

                f <- gframe("Click a button to raise a dialog", cont=vb)
                gbutton("galert", cont=f, handler=function(h, ...) {
                  galert("an alert message. This will self destruct in:  3, 2, 1, ... boom")
                })
                gbutton("gmessage", cont=f, handler=function(h, ...) {
                  gmessage("a message. Click 'cancel' to dismiss")
                })
                gbutton("gconfirm", cont=f, handler=function(h, ...) {
                  gconfirm("Really ok?", handler=function(...) {
                    galert("I guess that is okay")
                  })
                })
                gbutton("ginput", cont=f, handler=function(h, ...) {
                  ginput("Okay, what is your name", handler=function(h,...) {
                    galert(sprintf("Welcome %s", h$input))
                  })
                })
                gbutton("gbasicdialog", cont=f, handler=function(h, ...) {
                  w1 <- gbasicdialog("gbasicdialog", parent=w, width=600, height=400)
                  glabel("One can also use gwindow with a parent argument", cont=w1)
                  visible(w1) <- TRUE
                })
              }))


## ##################################################
## nm <- "huh"
## add_page(list(name=nm,
##               title=nm,
##               content=function(container) {
##                 vb <- gvbox(container)
##                 ghtml("
## DESCRIPTION
## ", markdown=TRUE,  cont=vb)

##                 ## other
##               }))



##################################################
## Let 'er rip
buttons <- Map(map_page, seq_along(pages), pages)
set_page(1)

