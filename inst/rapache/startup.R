## startup configuration file
## would be read in with
## RFileEval path_to_File...

require(gWidgetsWWW2.rapache)



## directory(ies) where scripts are searched for
options('gWidgetsWWW2.rapache::script_base' = 
        c(system.file('examples', package='gWidgetsWWW2.rapache')))


## basic template for a page. Might want to modify, though unlikely
options('gWidgetsWWW2.rapache::ui_template' = 
        system.file("templates", "ui.html", package="gWidgetsWWW2.rapache"))
