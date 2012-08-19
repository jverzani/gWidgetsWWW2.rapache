\name{gmenu}
\alias{gmenu}
\title{Menubar implementation}
\usage{
  gmenu(menulist, popup = FALSE, action = NULL,
    container = NULL, ..., ext.args = NULL)
}
\arguments{
  \item{menulist}{list of actions. Actions must have parent
  specified}

  \item{popup}{Logical. ignored for now}
}
\value{
  an ExtWidget object
}
\description{
  A menubar for gwindow instances. Menu items are specified
  with a named list. The heirarchical nature of the list
  maps to the heirarchical menu structure, with the names
  giving the menu names. The menu actions are specified
  using \code{gaction} elements. These may also be
  \code{gseperator()} instances.
}
\details{
  Menubars should only be added to \code{gwindow}
  instances, but this is not strictly enforced, any
  \code{Ext.Panel}-based container would do.

  Menubars can take checkboxes and radio buttons. Specify
  them without a parent container.
}
\examples{
w <- gwindow()
sb <- gstatusbar("Powered by gWidgetsWWW and Rook", cont=w)
stub = function(...) galert("stub", parent=w)
l <- list(
File = list(open=gaction("Open", handler=stub, parent=w),
            new = gaction("New", handler=stub, parent=w),
            gseparator(),
            quit = gaction("Quit", handler=stub, parent=w)),
Edit = list(save = gaction("Save", handler=stub, parent=w),
            gcheckbox("some state", checked=TRUE, handler=stub)
            )
)
m <- gmenu(l, cont=w)
gtext("Text goes here", cont=w)
}

