## startup configuration file
## would be read in with
## RFileEval path_to_File...



## directory(ies) where scripts are searched for
options('gWidgetsWWW2.rapache::script_base' = 
        c(system.file('examples', package='gWidgetsWWW2.rapache')))

## favicon
options('gWidgetsWWW2.rapache::favicon' = "static_file/images/r-logo.png")


## basic template for a page. Might want to modify, though unlikely
options('gWidgetsWWW2.rapache::ui_template' = 
        system.file("templates", "ui.html", package="gWidgetsWWW2.rapache"))

options('gWidgetsWWW2.rapache::tmp_dir'="/tmp")

## Load this last, so options can take effect
require(gWidgetsWWW2.rapache)

## We need to connect redis to the underlying R session. This means redis should be started and listening on this port:

redisConnect(timeout=21474836L)
