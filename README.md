gWidgetsWWW2.rapache
====================

The `gWidgetsWWW2` package is used to create dynamic web pages with R code using the `gWidgets` API. While it works fine with the `Rook` package for serving content, it does not work with `rapache`. This package, `gWidgetsWWW2.rapache` aims to provide a reasonable subset of the `gWidgetsWWW2` package for use within `rapache`. The advantage being that pages can be served to an audience at a larger scale. The main reason for the slowness in `gWidgetsWWW2` is the reliance on reference classes, which make programming nicer, but work slowly with the necessary serialization of environments needed to process callbacks within R.


See the directory `inst/rapache` for installation instructions. The package relies on an underlying installation of `rapache` and a `redis` server (see http://redis.io). Configuring `rapache` is straightforward.  Basically one needs to configure a simple directive. See `inst/docs/gWidgetsWWW2_rapache.html` for an overview.


Some examples may be seen here http://www.math.csi.cuny.edu/gw/index.R .
