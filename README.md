gWidgetsWWW2.rapache
====================

The `gWidgetsWWW2` package is used to create dynamic web pages with R code using
the `gWidgets` API. While it works fine with the `Rook` package for serving content,
it does not work with `rapache`. This package aims to provide a reasonable subset
of the `gWidgetsWWW2` package for use within `rapache`. The advantage being that
pages can be served to an audience at a larger scale. The main reason for the slowness in `gWidgetsWWW2` is the reliance on reference classes, which make programming nicer, but work slowly with the necessary serialization of environments needed to process callbacks within R.

