## Show index page
require(whisker)

f <- list.files(system.file("examples", package="gWidgetsWWW2.rapache"), full=TRUE)
f <- Filter(function(x) !grepl("index.R|README",x), f)

nms <- lapply(f, function(i) list(nm=basename(i)))

tpl <- "
<h2>gWidgetsWWW2.rapache</h2>
<p>
The <code>gWidgetsWWW2.rapache</code> package allows webpages to be
written with <code>R</code> code using the <code>gWidgets</code>
interface. <br/>

The pages are served through the <code>apache</code>
webserver with the aid of Jeffrey
Horner's <code>rapache</code> module. <br/>

The package is a relative of
<code>gWidgetsWWW2</code>, which uses the <code>Rook</code> package
to serve pages locally through <code>R</code>'s
internal web server.
</p>

<h3>Details</h3>
Some details on the package can be read
<a href='static_file/html/gWidgetsWWW2_rapache.html' target='_blank'>here</a>.


<h3>Examples</h3>
<ul>
{{#nms}}
<li>
  (<a href=https://raw.github.com/jverzani/gWidgetsWWW2.rapache/master/inst/examples/{{nm}} target='_blank'>source</a>)
  &nbsp; <a href='{{nm}}' target='_blank'>See example</a>
   {{nm}}
</li>
{{/nms}}
</ul>
"

w <- gwindow("gWidgetsWWW2.rapache")
sb <- gstatusbar("Powered by gWidgetsWWW2.rapache and rapache", cont=w)

g <- ggroup(cont=w, spacing=10)
ghtml(whisker.render(tpl), cont=g)
