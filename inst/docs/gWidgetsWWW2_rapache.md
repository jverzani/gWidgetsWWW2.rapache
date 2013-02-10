
<script type="text/javascript"> 
var student_answers = {};
var comments = {missing:"Missing answer", correct:"Correct", incorrect:"Incorrect"};
var student_id = "{{{STUDENT_ID}}}";
var page_id = "{{{PAGE_ID}}}";
</script>


<link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.0.4/css/bootstrap-combined.min.css" rel="stylesheet" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>

<script src="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.0.4/js/bootstrap.min.js"></script>

<script src="https://raw.github.com/jverzani/wmd/master/showdown.js"></script>
<script src="https://raw.github.com/jverzani/wmd/master/manipulate.js"></script>

<script>
var manipulate = function(form_id, graph_id, inputs,  expression) {

    var render = function(template, values) {
       for (value in values) {template = template.replace(new RegExp('%' + value + '%', 'g'), values[value], 'g');}
       return(template);
    }
    var rnd_id = (((1+Math.random())*0x10000)|0).toString(16).substring(1); // oops, from internet search (who?)

    var converter = new Showdown.converter();
    html = converter.makeHtml(inputs);              // make HTML from markup

    $("#" + form_id).append("<form action='#' id='" + rnd_id + "'>" + html + "</form>") ; // class='form-horizontal' gives wider layout
    $("#" + graph_id).append("<img src='data:image/gif;base64,R0lGODlhAQABAID/AMDAwAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=='></img>"); //blank

    $('.noEnterSubmit').keypress(function(e){
        if ( e.which == 13 ) return e.preventDefault();
    });

    var call_expression = function(params, expression) {
        var tmp = {}
        $.each(params, function() {console.log(this.value); tmp[this.name] = this.value});
        var out = render(expression, tmp);

	$.post("https://public.opencpu.org/R/pub/base/identity/save",
	       {x:out}, function(data, status, xhr) {
		   var data = JSON.parse(data)
                   $("#" + graph_id).children()[0].src = "https://public.opencpu.org/R/tmp/" + data.graphs[0] + "/png"
	       })
    };

    $("#" + form_id).on("change ", ':input:not([type="submit"])', function() { //change input
         call_expression($("#" + rnd_id).serializeArray(), expression);
    })
   call_expression($("#" + rnd_id).serializeArray(), expression);
}
</script>

<div id='main_message'></div>



<header class="jumbotron subhead"><h1>gWidgetsWWW2.rapache</h1><p class='lead'>Programming web pages with the gWidgets API</p></header>

<span><div id="navbar" class="navbar  navbar-fixed-top"><div class="navbar-inner"><ul id="navbar-header" class="nav"></ul></div></div></span><span id="subnav"></span>



<script>$('#navbar-header').append("<li><a href='#nav1' target='_self'>About</a></li>");</script>
<span><div id="nav1"></div></span>
<span><div class='page-header'><h2>About</h2></div></span>
   
The `gWidgetsWWW2.rapache` package implements most of the `gWidgets`
API to program interactive web pages with pure `R` code.

The `gWidgets` API is a simple-to-learn set of constructors and
methods that make easy the specifying of widgets for a GUI, their
layout and their interactions. The API is implemented, to varying
degrees, for use with the `RGtk2`, `tcltk` and `qtbase` packages to
make desktop GUIs. This package provides the ability to serve such
interfacess with the `apache` web server through Jeffrey Horner's `rapache`
module linking `R` with `apache.

Implementing the API for web programming took some iterations. The
`gWidgetsWWW` package (documented in the JSS article
http://www.jstatsoft.org/v49/i10/) was the first start. That package
was rewritten to take advantage of the `Rook` package interfacing with
`R`'s httpd server and incorporated reference classes instead of the
`proto` package. The result was `gWidgetsWWW2`. With that package,
serving pages locally through `Rook` works fine, but the package did
not play nicely with `rapache` to serve pages remotely. (One could use
`Rook` for this, but that method doesn't scale well.)

This package, `gWidgetsWWW2.rapache`, then is a rewrite of the
plumbing to serve pages through apache and a streamlining of some of
the functionality. The main technical issue involved having the
callbacks in R share their environment amongst potentially many `R`
processes spawned by `apache`. The solution used was to work to make
these environments small enough that they can be
serialized/unserialized to disk in a reasonable amount of time.


<script>$('#navbar-header').append("<li><a href='#nav2' target='_self'>Basic usage</a></li>");</script>
<span><div id="nav2"></div></span>
<span><div class='page-header'><h2>Basic usage</h2></div></span>

Once installed (see below) the use of the package is fairly
simple. One places a script into the appropriate directory. The name
of this script then maps to the URL that will call the script. A
simple "hello-world" script might look like:

```
w <- gwindow('Hello world title')
g <- gvbox(cont=w)
b <- gbutton('Click me world', cont=g)
addHandlerChanged(b, function(h,...) {
  galert('Hello world!')
})
```

The above script demonstrates the main points of the package:

* A toplevel window maps to a web page (`gwindow`)

* Containers are used to organize the layout (`gvbox` is a vertical
  box container)

* Controls are used to give the user a place to interact with
  (`gbutton`)

* dialogs can be called (`galert`)

* interactivity is created by adding a handler
  (`addHandlerChanged`). A handler, or callback, is an `R` function
  that is evaluated in an event driven manner. In this case, the
  "changed" event for a button object is triggered when the button is
  clicked. The callback above produces some JavaScript that causes a
  message to flash briefly on the screen.

If this script is saved as `test.R` in the proper directory, then the
page will load through a url such as
http://www.youraddress.com/gw/test.R .

There are more examples in the `examples` directory of the
package. A default installation has these accessible out of the box.



<script>$('#navbar-header').append("<li><a href='#nav3' target='_self'>Components</a></li>");</script>
<span><div id="nav3"></div></span>
<span><div class='page-header'><h2>Components&nbsp;<small>containers and controls</small></h2></div></span>

<h3>Containers</h3>

Containers are used to organize components (controls or other
containers). Unlike some GUI toolkits, the layout of child components
is integrated into the specification of the widget. The widget
constructors have a `container` argument where the parent is
specified. (E.g., above we had `gvbox(cont=w)` to next the vertical
box container inside the top-level window.) `Layout arguments are
given at the time of construction, such as `expand` or `fill`.

The package implements most -- but not all -- of the containers in the
`gWidgets` API:

* box containers, which pack children in left to right (horizontal) or
  top to bottom (vertical): `ggroup`, `gvbox` (a vertical box),
  `gframe` (a decorated box) and `gexpandgroup` (a box with a
  disclosure icon to hide or show the contents).

* a page layout container `gborderlayout` for placing widgets at the
  center or any of the four compass directions. These panels may have
  optional titles and disclosure buttons.

* a notebook container (`gnotebook`) and the card container
  (`gstackwidget`) for displaying multiple pages one at a time

* a container for forms `gformlayout` that holds labels and controls
  in an neatly organized manner.

Not implemented are the table layout container (`glayout`) and the
paned container (`gpanedgroup`). The `gformlayout` container covers
most uses of the former and the latter can be implemented with
`gborderlayout` (though that container does not like to be nested
within other containers.)

Containers have just a few methods:

* `visible<-` can be used to adjust if the components are visible

* `delete` can be used to remove a child component. Use `add` to
  restore.


<h3>Controls</h3>

The `gWidgets` API has several controls specified. A control allows
the user to interact with the GUI or the programmer to display
information for the user. Most controls have some event that will
trigger a callback, if specified. For most controls, this event is
clear and is identified through the generic `addHandlerChanged`. As
seen above, for a button this is the clicking of the button. A few
controls have more than one event they can respond. For these, there
are other `addHandlerXXX` methods.


The basic controls are:

* labeling controls: `glabel`, `gstatusbar`, `ghtml`, `gseparator`

* action controls: `gbutton`, `gmenu` (but there is no
  `gtoolbar`). These can be configured with sharable `gaction`
  instances.

* text controls: `gedit` (single line) and `gtext` (multi-line)

* selection controls: `gcheckbox`, `gradio`, `gcheckboxgroup`,
  `gcombobox`, `gtable` (with `selection="checkbox"`), `gslider`,
  `gspinbutton`

* table displays: `gtable` (`gdf` is not (yet) implemented in
  `gWidgetsWWW2.rapache` but is in `gWidgetsWWW2`)

* graphics displays: `gimage`, `gcanvas`, `gsvg`

* `gpanel` for incorporating external JavaScript libraries

* `gfile` for uploading files

Implemented in `gWidgetsWWW2` but not (yet) in `gWidgetsWWW2.rapache`
are `gtree`, `ggooglemaps`, and `gdf`.


The main widget methods are

* `svalue` and `svalue<-` for getting and setting the widget's main property

* `[` and `[<-` for accessing the items that selection can occur from
  (for the selection widgets). For such widgets, the S3 methods
  `names`, `length` and `dim` are typically implemented.

* `enabled<-` to change if a widget is sensitive to user input

* `visible<-` to change some visibility property of the widget. (There
  are many overloads, but the default is to specify if a widget is
  shown or hidden. One overload is for `gtable` objects, where this
  method is use to show or hide rows of the displayed data.)

* `tooltip<-` to specify a tooltip when the mouse hovers over the widget.


<script>$('#navbar-header').append("<li><a href='#nav4' target='_self'>Handlers</a></li>");</script>
<span><div id="nav4"></div></span>
<span><div class='page-header'><h2>Handlers</h2></div></span>


In addition to user-defined callbacks, all widgets with a state have a
transport handler defined for it that copies changes in the GUI back
to the `R` process. As such, these callbacks happen often. Each callback
requires the handling `R` process to unserialize an environment
containing the scope of the callback, call the handler, then serialize
the environment so it can be shared with other processes. This should
happen quickly. To make this the case, the environment must be kept
small. (In `gWidgetsWWW2` it was seen that environments with reference
classes do not serialize small and so this took far too long.) To
ensure that a few compromises are needed:

* you should avoid reference classes

* you will need to load packages in the handler call. Packages
  attached during a script (not loaded when `rapache` is) are not
  recorded or restored when the serialization takes place.

By employing these compromises, the response time for handling an
event was kept down to between 30 and 100ms. Not great, but
acceptable. We don't try to track keystrokes in `gedit` or all updates
for the `gslider` widget, but otherwise, most things work with this
response time.

<h3>gtimer</h3>

The `gtimer` constructor can be used to call a handler after some
prescribed period of time. The call can be repeated (the default) or
be `one.shot`. This can be useful, say, if a long running process is
implemented. The user can interact with multiple R processes, so even
if one is tied up on a long computation, the interface should still be
usable. The `gtimer` constructor should be able to poll until the
process is complete to carry back the results to the browser.

The `manipulate` example shows one use of `gtimer` that unfortunately
has no better idiom within this framework. That example has several
combo boxes. The value of a combobox is only available after the data
is loaded. This is done asynchronously. As such, the initial graphic
can not be made until after some unknow period. Unfortunately, there
is no hook (in `gWidgetsWWW2.rapache`) to defer the graphic call to
happen until after that event. Instead, we just use a one-shot timer
with a heuristically chosen delay to pause before making the call to
create the initial graphic.


<script>$('#navbar-header').append("<li><a href='#nav5' target='_self'>Graphics</a></li>");</script>
<span><div id="nav5"></div></span>
<span><div class='page-header'><h2>Graphics</h2></div></span>

The display of graphics has several different options:

* one can display images created through the `png` driver, say, with
  the `gimage` widget

* one can display svg files created with the `svg` driver (or others)
  with the `gsvg` widget

* one can use the `canvas` package to display graphics through
  `gcanvas`.

The `gcanvas` solution is best for quickly refreshing a graph produced
with R's base graphics. It does not work with lattice graphics or
`ggplot2`. One can do low level commands on the JavaScript `canvas`
object.

The `gsvg` solution is arguably the best looking, but flickers when
the graphic is refreshed making it not such a great choice for
interactive graphics.

The `gimage` solution looks fine and is nearly as responsive as
`gcanvas`.

There are a few examples in the `examples` directory including an
implementation of RStudio's `manipulate` package which shows how all
three can be used.


<script>$('#navbar-header').append("<li><a href='#nav6' target='_self'>Data</a></li>");</script>
<span><div id="nav6"></div></span>
<span><div class='page-header'><h2>Data&nbsp;<small>uploads</small></h2></div></span>

The `gfile` constructor can be used to allow a user to upload data to
the server. A cap on the size of the upload can be specified when
`rapache` is configured.

The widget calls any `upload` callback when the data is successfully
uploaded. The example in the `examples` directory shows how
`gstackwidget` can be used to open a new page once the data is
uploaded. Otherwise, the callback can update portions of the current
GUI to reflect the change in state.

The uploaded file and its name are passed back to the callback via the
`svalue` method (the path of the uploaded file) and `[` (the original
name).


<script>$('#navbar-header').append("<li><a href='#nav7' target='_self'>Persistence</a></li>");</script>
<span><div id="nav7"></div></span>
<span><div class='page-header'><h2>Persistence</h2></div></span>

Each time a page is loaded (even when refreshed) a new environment is
made for evaluating any callbacks. As such, the data within a page is
not persistent across page loads unless it is programmed to be so. One
can write to the file system or data base to keep values across
sessions. (The package uses a `redis` server for this purpose.)


<script>$('#navbar-header').append("<li><a href='#nav8' target='_self'>Start up</a></li>");</script>
<span><div id="nav8"></div></span>
<span><div class='page-header'><h2>Start up</h2></div></span>

The initial web page is constructed through various stages:

* a basic template is loaded

* some large `JavaScript` libraries are loaded from CDNs. These will
  be slow the first time, but should be cached so subsequent reloads
  are not lengthy

* Then a unique session ID is fetched from the server

* Then the `JavaScript` that creates the page layout is fetched from
  the server

* Finally the browser uses this `JavaScript` to layout out the page.

Of these, the time of the last two steps depends on the complexity of
the GUI design. In basic testing with a modest machine, each
additional widget takes about 40ms to load with a base initialization
of around 100ms (40ms is a minimum, more complex widgets will take
longer). So a not-so-complex interface with 20 or so widgets will take
around 1 second or more to fetch from the server. It may take another
second for the browser to actually process the `JavaScript`. Once
loaded the pages are fairly responsive, but the initial loading can
seem somewhat slow. A loading mask it employed to indicate that
activity is taking place.



<script>$('#navbar-header').append("<li><a href='#nav9' target='_self'>JavaScript</a></li>");</script>
<span><div id="nav9"></div></span>
<span><div class='page-header'><h2>JavaScript</h2></div></span>

The package uses the `ExtJS` libraries provided by `sencha.com`. These
are widely used in commercial and GPL projects. There may be some
restrictions on their use in your project, there may not be. I don't
know and don't want to. 

`JavaScript` is a language that can be used to manipulate a web page
in numerous ways. The package makes no assumption that an R user knows
`JavaScript`. Rather, its novelty is to make it easy for non-web
programmers to create web pages. That being said, there are a few ways
one with `JavaScript` knowledge can integrate that into the framework.

The `ExtJS` API is very rich and far more extensive than that provided
by `gWidgets`. The function `call_ext` can be used to call a method on
an object not available through the base interface.

Each constructor has an argument `ext.args` for passing in extra
arguments to the `ExtJS` constructor. This is specified with a list
that is converted to a `JavaScript` object through the function
`list_to_object`.

When a callback is run, the package creates `JavaScript` to pass back
to the browser. So a command like `svalue(obj) <- "some value"` will
produce the appropriate `JavaScript`. Each command has its
`JavaScript` added to a queue. One can add their own `JavaScript`
commands to the queue via the `push_queue` function. For example, to
use the browsers alert dialog add this to a handler

```
push_queue("alert('hello world')")
```

Finally, the `gpanel` widget does nothing more than make a `DIV` tag
on the page to be filled in by `JavaScript`. The widget allows one to
load some external `JavaScript` code asynchronously and call a handler
once loaded.




<script>$('#navbar-header').append("<li><a href='#nav10' target='_self'>Security</a></li>");</script>
<span><div id="nav10"></div></span>
<span><div class='page-header'><h2>Security</h2></div></span>

Web security is a big deal. There is the potential for malicious
intent on the part of a user. This package provides no additional
security features, but standard web safety guidelines should be
followed. (E.g., don't eval code that a user can upload, ...) With
the advent of cloud-based servers, you might want to deploy your
server in a stand-alone manner.


<script>$('#navbar-header').append("<li><a href='#nav11' target='_self'>Debugging</a></li>");</script>
<span><div id="nav11"></div></span>
<span><div class='page-header'><h2>Debugging</h2></div></span>

Debugging scripts is made more difficult, as the scripts must be
processed through the browser. Here are some useful tricks:

* A test setup is useful where a local `apache` server is used. (This
  isn't helpful for windows users). Most -- but not all -- scripts can
  be tested locally with `gWidgetsWWW2` under `Rook`. There are a few
  differences in the API though, so this won't be fool proofed.

* Errors are logged in apache's log file

* `print` statements do not appear in the log file, but those
  generated with `message` appear in apache's log file. This can be
  useful to track down issues with the script.

* There may be errors in `gWidgetsWWW2.rapache` that are `JavaScript`
  errors. Of course, the package author would love to hear about this,
  so they can be fixed. But how can the end user tell? Well, a
  `JavaScript` console can be used. The main browsers include these:
  Chrome and Safari have built in ones available through the menu bar,
  Firefox has the excellent `firebug` add on http://getfirebug.com/ .


<script>$('#navbar-header').append("<li><a href='#nav12' target='_self'>Installation:</a></li>");</script>
<span><div id="nav12"></div></span>
<span><div class='page-header'><h2>Installation:&nbsp;<small>rapache configuration</small></h2></div></span>

Installing this software requires a few steps:

* the package needs to be installed in such a way that the R process
  spawned by the web server can see the package (i.e., do not use a
  local directory)

```
require(devtools)
install_github("gWidgetsWWW2.rapache", "jverzani")
```

* rapache must be installed (follow the instructions here
  http://www.rapache.net).

* rapache must be configured. There are 2-3 steps:

- The `mod_R.so` module must be loaded. Likely this is already done,
  but if not you must add this to your apache configuration:

```
LoadModule R_module /usr/libexec/apache2/mod_R.so
```

  The location of `mod_R.so` is system dependent, the above is a Mac
  OS X installation point.

- Some basic customization must be made. The defaults are installed
  through the apache directive:

```
RSourceOnStartup 'system.file("rapache", startup.R", package="gWidgetsWWW2.rapache")'
```



Alternatively, one can copy that file to the file system and modify
it. The option `gWidgetsWWW2.rapache::script_base` is the most
important, as this specifies where to look for files.

- The following `Location` directive is given defining the urls for your scripts:

```
<Location /gw>
     LimitRequestBody 1024000
     SetHandler r-handler
     ## from system.file("rapache", "www2.R", package="gWidgetsWWW2.rapache")
     RFileHandler /Library/Frameworks/R.framework/Versions/2.15/Resources/library/gWidgetsWWW2.rapache/rapache/www2.R
</Location>
```

The above uses the base url `http://your.address.com/gw/` for accessing
scripts. (So the url `http://your.address.com/gw/ex.R` causes a search
for the file `ex.R` in the directory (directories) specified through
the option `gWidgetsWWW2.rapache::script_base`.

The `LimitRequestBody` limits the size of file uploads. A value of 0
is use to indicate no limit.

The path of the `www2.R` script comes from invoking `system.file` with
the appropriate commands, as indicated in the comment. Alternatively,
this script can be copied and modified should there be a need.

One could add to the above apache configuration, say restricting
access using one of apache's modules.


That's it. Not much harder than installing `rapache` itself. With the
default installation, the examples directory from the package is where
URLs will be mapped to. Going to `http://your.address.com/gw/` will
open a page with links.


<!--- Finish this off -->


<script>
$('body').css('margin', '40px 10px');

$('body').attr('data-spy','scroll');
</script>

<div id='grade_alert'></div>
<script>

var tmp = $(".nav-tabs")

$.each(tmp, function(key, value) {
  $("#" + value.id + " a:first").tab("show")
});
 
$("#navbar").scrollspy();

$("body").attr("data-spy", "scroll");

$("[data-spy=\'scroll\']").each(function () {
  var $spy = $(this).scrollspy("refresh")
});

(function(a){function b(a,b){var c=(a&65535)+(b&65535),d=(a>>16)+(b>>16)+(c>>16);return d<<16|c&65535}function c(a,b){return a<<b|a>>>32-b}function d(a,d,e,f,g,h){return b(c(b(b(d,a),b(f,h)),g),e)}function e(a,b,c,e,f,g,h){return d(b&c|~b&e,a,b,f,g,h)}function f(a,b,c,e,f,g,h){return d(b&e|c&~e,a,b,f,g,h)}function g(a,b,c,e,f,g,h){return d(b^c^e,a,b,f,g,h)}function h(a,b,c,e,f,g,h){return d(c^(b|~e),a,b,f,g,h)}function i(a,c){a[c>>5]|=128<<c%32,a[(c+64>>>9<<4)+14]=c;var d,i,j,k,l,m=1732584193,n=-271733879,o=-1732584194,p=271733878;for(d=0;d<a.length;d+=16)i=m,j=n,k=o,l=p,m=e(m,n,o,p,a[d],7,-680876936),p=e(p,m,n,o,a[d+1],12,-389564586),o=e(o,p,m,n,a[d+2],17,606105819),n=e(n,o,p,m,a[d+3],22,-1044525330),m=e(m,n,o,p,a[d+4],7,-176418897),p=e(p,m,n,o,a[d+5],12,1200080426),o=e(o,p,m,n,a[d+6],17,-1473231341),n=e(n,o,p,m,a[d+7],22,-45705983),m=e(m,n,o,p,a[d+8],7,1770035416),p=e(p,m,n,o,a[d+9],12,-1958414417),o=e(o,p,m,n,a[d+10],17,-42063),n=e(n,o,p,m,a[d+11],22,-1990404162),m=e(m,n,o,p,a[d+12],7,1804603682),p=e(p,m,n,o,a[d+13],12,-40341101),o=e(o,p,m,n,a[d+14],17,-1502002290),n=e(n,o,p,m,a[d+15],22,1236535329),m=f(m,n,o,p,a[d+1],5,-165796510),p=f(p,m,n,o,a[d+6],9,-1069501632),o=f(o,p,m,n,a[d+11],14,643717713),n=f(n,o,p,m,a[d],20,-373897302),m=f(m,n,o,p,a[d+5],5,-701558691),p=f(p,m,n,o,a[d+10],9,38016083),o=f(o,p,m,n,a[d+15],14,-660478335),n=f(n,o,p,m,a[d+4],20,-405537848),m=f(m,n,o,p,a[d+9],5,568446438),p=f(p,m,n,o,a[d+14],9,-1019803690),o=f(o,p,m,n,a[d+3],14,-187363961),n=f(n,o,p,m,a[d+8],20,1163531501),m=f(m,n,o,p,a[d+13],5,-1444681467),p=f(p,m,n,o,a[d+2],9,-51403784),o=f(o,p,m,n,a[d+7],14,1735328473),n=f(n,o,p,m,a[d+12],20,-1926607734),m=g(m,n,o,p,a[d+5],4,-378558),p=g(p,m,n,o,a[d+8],11,-2022574463),o=g(o,p,m,n,a[d+11],16,1839030562),n=g(n,o,p,m,a[d+14],23,-35309556),m=g(m,n,o,p,a[d+1],4,-1530992060),p=g(p,m,n,o,a[d+4],11,1272893353),o=g(o,p,m,n,a[d+7],16,-155497632),n=g(n,o,p,m,a[d+10],23,-1094730640),m=g(m,n,o,p,a[d+13],4,681279174),p=g(p,m,n,o,a[d],11,-358537222),o=g(o,p,m,n,a[d+3],16,-722521979),n=g(n,o,p,m,a[d+6],23,76029189),m=g(m,n,o,p,a[d+9],4,-640364487),p=g(p,m,n,o,a[d+12],11,-421815835),o=g(o,p,m,n,a[d+15],16,530742520),n=g(n,o,p,m,a[d+2],23,-995338651),m=h(m,n,o,p,a[d],6,-198630844),p=h(p,m,n,o,a[d+7],10,1126891415),o=h(o,p,m,n,a[d+14],15,-1416354905),n=h(n,o,p,m,a[d+5],21,-57434055),m=h(m,n,o,p,a[d+12],6,1700485571),p=h(p,m,n,o,a[d+3],10,-1894986606),o=h(o,p,m,n,a[d+10],15,-1051523),n=h(n,o,p,m,a[d+1],21,-2054922799),m=h(m,n,o,p,a[d+8],6,1873313359),p=h(p,m,n,o,a[d+15],10,-30611744),o=h(o,p,m,n,a[d+6],15,-1560198380),n=h(n,o,p,m,a[d+13],21,1309151649),m=h(m,n,o,p,a[d+4],6,-145523070),p=h(p,m,n,o,a[d+11],10,-1120210379),o=h(o,p,m,n,a[d+2],15,718787259),n=h(n,o,p,m,a[d+9],21,-343485551),m=b(m,i),n=b(n,j),o=b(o,k),p=b(p,l);return[m,n,o,p]}function j(a){var b,c="";for(b=0;b<a.length*32;b+=8)c+=String.fromCharCode(a[b>>5]>>>b%32&255);return c}function k(a){var b,c=[];c[(a.length>>2)-1]=undefined;for(b=0;b<c.length;b+=1)c[b]=0;for(b=0;b<a.length*8;b+=8)c[b>>5]|=(a.charCodeAt(b/8)&255)<<b%32;return c}function l(a){return j(i(k(a),a.length*8))}function m(a,b){var c,d=k(a),e=[],f=[],g;e[15]=f[15]=undefined,d.length>16&&(d=i(d,a.length*8));for(c=0;c<16;c+=1)e[c]=d[c]^909522486,f[c]=d[c]^1549556828;return g=i(e.concat(k(b)),512+b.length*8),j(i(f.concat(g),640))}function n(a){var b="0123456789abcdef",c="",d,e;for(e=0;e<a.length;e+=1)d=a.charCodeAt(e),c+=b.charAt(d>>>4&15)+b.charAt(d&15);return c}function o(a){return unescape(encodeURIComponent(a))}function p(a){return l(o(a))}function q(a){return n(p(a))}function r(a,b){return m(o(a),o(b))}function s(a,b){return n(r(a,b))}function t(a,b,c){return b?c?r(b,a):s(b,a):c?p(a):q(a)}"use strict",typeof define=="function"&&define.amd?define(function(){return t}):a.md5=t})(this);

function comment_default(grade, stud_ans, comment, def) {
    var cmt = "";
    if(grade == 100) {
	cmt = def.correct;
    } else if(typeof(comment) != "undefined") {
	if(typeof(comment[stud_ans]) != "undefined") {
	    cmt = comment[stud_ans];
	} else {
	    cmt = def.incorrect;
	}
    } else {
	cmt = def.incorrect;
    }
    return cmt;
};

function comment_checkgroup(grade, stud_ans, comment, def) {
    var tmp = []; 
    $.each(stud_ans, function(key, value) {if(value !== null) tmp.push(value)});
    return comment_default(grade, tmp.sort().join("::"), comment, def);
};

function comment_numeric(grade, stud_ans, value, comment, def) {
    var cmt = "";
    if(grade == 100) {
	cmt = def.correct;
    } else if(typeof(comment) != "undefined") {
	if(stud_ans < value[0]) {
	    if(typeof(comment.less) != "undefined") {
		cmt = comment.less
	    } else {
		cmt = def.incorrect
	    }
	} else if(stud_ans > value[1]) {
	    if(typeof(comment.more) != "undefined") {
		cmt = comment.more
	    } else {
		cmt = def.incorrect
	    }
	}
    } else {
	cmt = def.incorrect;
    }
    return cmt;
}
function grade_radio(ans, value) {console.log(ans + ":" + value);ans=ans.replace(/\\/g, "").replace(/\s/g,"");value=value.replace(/\\/g,"").replace(/\s/g,""); return( ans == value ? 100 : 0) };
function grade_checkboxgroup(ans, value) {
  var out=[];
  $.each(ans, function(key, value) { if(value != null) { out.push(value) }});
  if(out.length != value.length) { return(0) };
  out = out.sort();
  var value = value.sort()
  for(var i=0; i < out.length; i++) {
    if(out[i] != value[i]) { return(0) }
  }
  return(100)
};
function grade_typeahead(ans, value) { return( (ans == value) ? 100 : 0 )};
function grade_combo(ans, value) { return( (ans == value) ? 100 : 0) };
function grade_numeric(ans, value) {var ans = parseFloat(ans); return( (ans >= value[0] && ans <= value[1]) ? 100 : 0) };



function submit_work(status) {
    $.ajax({
	url:"/set_answers",
	type:"POST",
	data: {
	    answers:JSON.stringify(student_answers),
	    status:status,
	    project_id:page_id
	},
	success:function(data) {
	    window.location.replace("");
	}
    });
};
var is_open=false;

function write_grade_table() {
    var a = student_answers;
    if(is_open) {
	$("#gradealert").alert('close');
    } else {
	$("#grade_alert").append('<div id = "fillmein"></div>');

	$("#fillmein").append('<div id="gradealert" class="alert alert-block fade in"><button class="close" data-dismiss="alert">×</button>');
	$("#gradealert").append('<h2>Congratulations, your scores so far are:</h2>');  
	$("#gradealert").append('<table id="grade_alert_table" class="table table-bordered table-striped">');
	$("#gradealert").append("</table></div>");
	
	$("#grade_alert_table").append('<thead><tr><th>Problem</th><th>Score</th><th>Comment</th></tr></thead><tbody>');

	var icon_lookup = {true:"icon-thumbs-up", false:"icon-thumbs-down", missing:"icon-warning-sign"};
	var msg_lookup = {true:"Correct", false: "Incorrect", missing:"Missing"};

	$.each(a, function() {
	    $("#grade_alert_table").append("<tr>" +
					   "<td>" + 
					   "<a class='grade_clicker' href='#" + this.problem + "' target='_self'>" +
					   "Problem " + this.problem.replace("prob_", "") + "</a></td>" +
					   " <td>" + 
					   "<i class='" + icon_lookup[this.grade] + "'></i>&nbsp;" +
					   msg_lookup[this.grade] + "</td>" +
					   "<td>" + this.comment + "</td>" +
					   "</tr>");
	})
	    $("#grade_alert_table").append('</tbody>');
	$(".grade_clicker").each(function() { this.onclick = function() {$("#gradealert").alert('close')}})
	    $("#gradealert").alert();
	is_open = true;
	$("#gradealert").bind("closed", function() {is_open=false});
    }
};
$(document).ready(function() {
    $(".btn").button()

    var cmt_defaults={correct:comments.correct, 
		      incorrect:comments.incorrect,
		      missing:comments.missing
		     };	
    var fix_badge = function(key, tries, answer, comment) {
	$('#' + key + "_badge").each(function() {this.innerHTML = tries + (tries == 1 ? " try" : " tries")});
	$.each(['badge-info', 'badge-warning', 'badge-success'], function(idx, value) {
	    $('#' + key + "_badge").removeClass(value)
	});
	if(answer == true) {
	    $('#' + key + "_badge").addClass("badge-success");
	} else {
	    $('#' + key + "_badge").addClass("badge-warning");
	};
	$('#' + key + "_help").each(function() {
	    this.innerHTML=
		"<div class='alert alert-info'><a class='close' data-dismiss='alert' href='#'>×</a>" + comment + "</div>";
	});
	
    }
    var close_comment = function(key) {
	$("#" + key + "_comment > .alert").alert("close");
    };
    $("[type=\'radio\']").each(function() {
	student_answers[this.name]={problem:this.name, type:'radio', tries:0};
	this.onchange = function() {
	    var key = this.name;
	    var sans = this.value;
	    var answer = grade_radio(sans, actual_answers[key].value);
	    var comment = comment_default(answer, sans, comments[key], cmt_defaults); 
	    var tries = student_answers[key].tries + 1;
	    student_answers[key] = {
		problem:key,
		type:'radio',
		tries:tries,
		answer:sans,
		grade:answer,
		comment:comment
	    };
	    fix_badge(key, tries, answer, comment);
	}
    }
			      );
    $("[type=\'checkbox\']").each(function() {
	var n = $("#" + this.name + "> .checkbox").length
	var ans = {};
	for(i=1; i <= n; i++) {ans[this.name + "_" + i] = null;}
	student_answers[this.name] = {
	    problem: this.name,
	    type:'checkbox',
	    tries:0,
	    answer:ans
	};
	this.onchange = function() {
	    var key = this.name;
	    var sans = student_answers[key].answer;
	    if(this.checked) {
		sans[this.id] = this.value;
	    } else {
		sans[this.id] = null;
	    }
	    var answer = grade_checkboxgroup(sans, actual_answers[key].value);
	    var comment = comment_checkgroup(answer, sans, comments[key], cmt_defaults); 
	    var tries = student_answers[key].tries + 1;

	    student_answers[key] = {
		problem:key,
		type:'checkbox',
		tries:tries,
		answer:sans,
		grade:answer,
		comment:comment
	    };
	    fix_badge(key, tries, answer, comment)
	}
    });
    $(".typeahead").each(function() {
	if(this.id.length > 0) {
	    student_answers[this.id]={problem:this.id, type:'typeahead',  tries:0};
	}
	this.onchange = function() {
	    var key = this.id;
	    var sans = this.value;
	    var answer = grade_typeahead(sans, actual_answers[key].value);
	    var comment = comment_default(answer, sans, comments[key], cmt_defaults); 
	    var tries = student_answers[key].tries + 1;

	    student_answers[key] = {
		problem:key,
		type:"typeahead",
		tries:student_answers[key].tries + 1,
		answer:sans,
		grade:answer,
		comment:comment
	    };
	    fix_badge(key, tries, answer, comment)
	}
    });
    
    $(".combobox").each(function() { 
	student_answers[this.id]={problem:this.id, type:'combo', tries:0};
	this.onchange = function() {
	    var key = this.id;
	    var sans = this.value;
	    var answer = grade_combo(sans, actual_answers[key].value);
	    var comment = comment_default(answer, sans, comments[key], cmt_defaults); 
	    var tries = student_answers[key].tries + 1;

	    student_answers[key] = {
		problem:key,
		type:"combo",
		tries:tries,
		answer:sans,
		grade:answer,
		comment:comment
	    };
	    fix_badge(key, tries, answer, comment)
	}
    });
    $(".numeric_answer").each(function() {
	student_answers[this.id]={problem:this.id, type:'numeric', tries:0};
	this.onchange = function() {
	    var key = this.id;
	    var sans = this.value;
	    var answer = grade_numeric(sans, actual_answers[key].value);
	    var comment = comment_numeric(answer, sans, 
					  actual_answers[key].value,
					  comments[key],
					  cmt_defaults); 
	    var tries = student_answers[key].tries + 1;

	    student_answers[key] = {
		problem:key,
		type:"numeric",
		tries:tries,
		answer:sans,
		grade:answer,
		comment:comment
	    };
	    fix_badge(key, tries, answer, comment)
	}
    });
    $(".free").each(function() {
	student_answers[this.id]={problem:this.id, type:'free', tries:0};
	this.onchange = function() {
	    var key = this.id;
	    var sans = this.value;
	    student_answers[key].answer = sans;
	};
    });

    
});
</script>
<script>var actual_answers=[];</script>

<script>comments={ "missing": "Missing answer","correct": "Correct answer","incorrect": "Incorrect answer" };</script>
