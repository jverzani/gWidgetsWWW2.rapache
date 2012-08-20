## startup configuration file
## would be read in with
## RFileEval path_to_File...

require(gWidgetsWWW2.rapache)

## base url
## XXX need to modify regexp for path info (/gw part)
options('gWidgetsWWW2.rapache::url_base' = '/custom/gw')

## directory(ies) where scripts are searched for
options('gWidgetsWWW2.rapache::script_base' = 
        c(system.file('examples', package='gWidgetsWWW2.rapache')))


## put in tpl configuration defaulting to
## tpl <- system.file("templates", "ui.html", package="gWidgetsWWW2.rapache")
## modify www2.R
