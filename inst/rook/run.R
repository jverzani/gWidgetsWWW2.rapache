
require("gWidgetsWWW2.rapache")
require(Rook)

s <- Rhttpd$new()
s$add(RhttpdApp$new(
    name="gw",
    app=system.file('rook', 'rook.R', package="gWidgetsWWW2.rapache")
))
s$add(RhttpdApp$new(
    name="gw_static",
    app=system.file('rook', 'static.R', package="gWidgetsWWW2.rapache")
))
s$start(port=8999L)
