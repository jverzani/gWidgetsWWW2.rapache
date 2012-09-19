
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
methods that make specifying the widgets for a GUI, their layout and
their interactions. The API is implemented to some degree for use with
the `RGtk2`, `tcltk` and `qtbase` packages for desktop GUIs. This
package provides the ability to serve such GUIs through the `apache`
server through Jeffrey Horner's `rapache` module linking `R` with
`apache.

Implementing the API for web programming took some iterations. The
`gWidgetsWWW` package (documented in the JSS article
http://www.jstatsoft.org/v49/i10/) was the first start. That package
was rewritten to take advantage of the `Rook` package interfacing with
`R`'s httpd server and incorporated reference classes instead of the
`proto` package. The result was `gWidgetsWWW2`. With that package,
serving pages locally through `Rook` works fine, but the package did
not play nicely with `rapache` to serve pages remotely. (One could use
`Rook` for this, but that method doesn't scale well.).

This package, `gWidgetsWWW2.rapache` then is a rewrite of the plumbing
to serve pages through apache. The main technical issue involves
having the callbacks in R share their environment amongst potentially
many `R` processes spawned by `apache`. The solution is to work really
hard to make these environments small enough that they can be
serialized/unserialized in a reasonable amount of time.


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


There are more examples in the `examples` directory of the package. A
default installation has these accessible out of the box.



<script>$('#navbar-header').append("<li><a href='#nav3' target='_self'>Containers and components</a></li>");</script>
<span><div id="nav3"></div></span>
<span><div class='page-header'><h2>Containers and components</h2></div></span>

<h4>Containers</h4>

Containers are used to organize components (controls or other
containers). Unlike some GUI toolkits, the layout of child components
is integrated into the specification of the widget. The widget
constructors have a `container` argument where the parent is
specified. Layout arguments are given at time of construction, such as
`expand` or `fill`.

The package implements most -- but not all -- of the containers in the `gWidgets` API:

* box containers which pack children in left to right (horizontal) or
  top to bottom(vertical): `ggroup`, `gvbox` (a vertical box),
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
most uses of the formal and the latter can be implemented with
`gborderlayout` (though that container does not like to be nested.)

Containers have just a few methods:

* `visible<-` can be used to adjust if the components are visible

* `delete` can be used to remove a child component. Use `add` to
  restore.


<h4>Controls</h4>

The `gWidgets` API has several controls specified. A control allows
the user to interact with the GUI or the programmer to display
information for the user. Most controls have some event that will
trigger a callback, if specified. For most controls, this event is
clear and is identified through `addHandlerChanged`. As seen, for a
button this is the clicking of the button. A few controls have more
than one event they can respond. For these, there are other
`addHandlerXXX` methods.


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

* graphics controls: `gimage`, `gcanvas`, `gsvg`

* `gpanel` for incorporating external JavaScript libraries

* `gfile` for uploading files

Implemented in `gWidgetsWWW2` but not (yet) in `gWidgetsWWW2.rapache`
are `gtree`, `ggooglemaps`, and `gdf`.


The main widget methods are

* `svalue` and `svalue<-` for getting and setting the widget's main property

* `[` and `[<-` for accessing the items that selection can occur from
  (for the selection widgets). For such widgets, the S3 methods
  `names`, `length` and `dim` are typically implemented.

* `enabled<-` to change is a widget is sensitive to user input

* `visible<-` to change some visibility property of the widget. (There
  are many overloads, but the default is to specify if a widget is
  shown or hidden.)

* `tooltip<-` to specify a tooltip when the mouse hovers over the widget.


<script>$('#navbar-header').append("<li><a href='#nav4' target='_self'>Handlers</a></li>");</script>
<span><div id="nav4"></div></span>
<span><div class='page-header'><h2>Handlers</h2></div></span>


The interactivity of the GUI is controlled by assigning callbacks (or
handlers) to events. The methods `addHandlerXXX` are used for
this. The generic call is `addHandlerChanged` which calls the callback
after the "typical" event. Some widgets may have more than one event
associated to it.

All widgets with a state have a transport handler defined for it that
copies changes in the GUI back to the R process.

As such, these callbacks happen often. Each callback requires the
handling R process to unserialize an environment, call the handler,
then serialize the environment. This should happen quickly. To make
this the case, the environment must be kept small. (In `gWidgetsWWW2`
it was seen that environments with reference classes do not serialize
small and so this took far too long.) To ensure that a few compromises
are needed:

* you should avoid reference classes

* you will need to load packages in the handler call. Packages
  attached during a script (not loaded when `rapache` is) are not
  recorded or restored when the serialization takes place.

By employing these, the response time for handling an event was kept
down to between 30 and 100ms. Not great, but acceptable. We don't try
to track keystrokes in `gedit` or all updates for the `gslider`
widget, but otherwise, most things work with this response time.

<h4>gtimer</h4>

The `gtimer` constructor can be used to call a handler after some
prescribed period of time. The call can be repeated (the default) or
be `one.shot`. This can be useful, say, if a long running process is
implemented. The user can interact with multiple R processes, so even
if one is tied up on a long computation, the interface should still be
usable. The `gtimer` constructor should be able to poll until the
process is complete to carry back the results to the browser.

The `manipulate` example shows one use of `gtimer` that unfortunately
has no better idiom within this framework. That example has several
comboboxes. The value of a combobox is only available after the data
is loaded. This is done asynchronously. As such, the initial graphic
can not be made until the comboboxes are loaded. But there is no hook
(in `gWidgetsWWW2.rapache`) to allow the graphic call to happen until
after that event. Instead, we just use a one-shot timer with a
heuristically chosen delay to pause before making the call to create
the initial graphic.


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
`ggplot2`.

The `gsvg` solution is arguably the best looking, but flickers when
the graphic is refreshed making it not such a great choice for
interactive graphics.

The `gimage` solution looks fine and is nearly as responsive as
`gcanvas`.

There are a few examples in the `examples` directory including an
implementation of RStudio's `manipulate` package which uses all three.


<script>$('#navbar-header').append("<li><a href='#nav6' target='_self'>Data uploads</a></li>");</script>
<span><div id="nav6"></div></span>
<span><div class='page-header'><h2>Data uploads</h2></div></span>

The `gfile` constructor can be used to allow a user to upload data to
the server. A cap on the size of the upload can be specified when
`rapache` is configured.

The constructor call any `upload` callback when the data is
successfully uploaded. The example in the `examples` directory shows
how using `gstackwidget` a new page can be created once the data is
uploaded. Otherwise, the callback can update portions of the current
GUI to reflect the change in state.

The uploaded file and its name are passed back to the callback via the
`svalue` method (the path of the uploaded file) and `[` (the original
name).



<script>$('#navbar-header').append("<li><a href='#nav7' target='_self'>Security</a></li>");</script>
<span><div id="nav7"></div></span>
<span><div class='page-header'><h2>Security</h2></div></span>

Web security is a big deal. There is the potential for malicious
intent on the part of a user. This package provides no additional
security features, but standard web safety guidelines should be
followed. (E.g., don't eval code that a user can upload, ...)


<script>$('#navbar-header').append("<li><a href='#nav8' target='_self'>Installation: rapache configuration</a></li>");</script>
<span><div id="nav8"></div></span>
<span><div class='page-header'><h2>Installation: rapache configuration</h2></div></span>

Installing this software requires a few steps:

* the package needs to be installed in such a way that the R process
  spawned by the web server can see the package (not a local
  directory)

```
require(devtools)
install_github("gWidgetsWWW2.rapache", "jverzani")
```

* rapache must be installed (http://www.rapache.net)

* rapache must be configured. There are 2-3 steps:

- The `mod_R.so` module must be loaded. Likely this is already done,
  but if not you must add this to your apache configuration:

```
LoadModule R_module /usr/libexec/apache2/mod_R.so
```

- Some basic customization must be made. The defaults are installed
  through the apache directive:

```
RSourceOnStartup('system.file("rapache", startup.R", package="gWidgetsWWW2.rapache")')
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

The above uses the base url `http://your.address.com/gw` for accessing
scripts. (So the url `http://your.address.com/gw/ex.R` causes a search
for the file `ex.R` in the directory (directories) specified through
the option `gWidgetsWWW2.rapache::script_base`.

The `LimitRequestBody` limits the size of file uploads. A value of 0
is unlimited.

The path of the `www2.R` script comes from invoking `system.file` with
the appropriate commands. Alternatively, this script can be copied and
modified should there be a need.

One could add to the above apache configuration, say restricting
access using one of apache's modules.


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

function set_radio(id, value) {
  $("#" + id + " [value=" + value + "]").attr("checked", true);
};

function set_checkboxgroup(id, value) {
  $("#" + id + " [type=checkbox]").attr("checked", false);
  $.each(value, function(idx, val) {
    $("#" + id + " [value=" + val + "]").attr("checked", true)
  })
};


function set_typeahead(id, value) {
    $("#" + id).val(value)
};

function set_combo(id, value) {
    if(value.length > 0) {
	$("#" + id + " [value=" + value + "]").attr("selected", true)
    } else {
	$("#" + id)[0].selectedIndex=0;
    }

};

function set_numeric(id, value) {
    $("#" + id).val(value)
};

function set_free(id, value) {
    $("#" + id).val(value);
};

function set_answer(o) {
    var id = o.problem; 
    var value = o.answer;
    var type = o.type
    if(type == "radio") {
	set_radio(id, value)
    } else if(type == "checkbox") {
	set_checkboxgroup(id, value)
    } else if(type == "typeahead") {
	set_typeahead(id, value)
    } else if(type == "combo") {
	set_combo(id, value)
    } else if(type == "numeric") {
	set_numeric(id, value)
    } else if(type == "free") {
	set_free(id, value)
    }
};

function set_answers(status, stud_ans) {
    $.each(stud_ans, function(key, value) {
	set_answer(value);
	if(typeof(value.comment) != "undefined") {
	    var cmt = '<div class="alert"><a class="close" data-dismiss="alert" href="#">×</a>' + value.comment + '</div>'
	    var x =  $("#" + value.problem + "_help");
	    if(x.length > 0) {
		x[0].innerHTML = cmt;
	    }
	    if(status == "graded") {
		var x =  $("#" + value.problem + "_comment");
		if(x.length > 0) {
		    x[0].innerHTML = cmt;
		}
	    }
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

    var restore_badges = function(x) {
    $.each(x, function(key, value) {
	var badge = $("#" + key + "_badge");
	if(badge.length > 0) {
	    var tries = x[key].tries;
	    badge[0].innerHTML = tries + " tries"
	}
    })
}
    // get answers from server, restore
    $.ajax({
	url:"http://localhost:9000/custom/quizr/get_answers", 
	type:'POST',
	data:{ project_id:page_id}, 
	success:function(data, status, jqxhr) {
	   
	    if(data.status == "error") {
		return null;
	    }
	    
	    student_answers = data.answers;
	    set_answers(data.status, data.answers);
	    restore_badges(student_answers);

	    if(data.status == "graded") {
		// no more changes!
		$("button").addClass("disabled");
		$("button").each(function() {this.onclick=null});
		    
		$.each($('[id*="prob"]'), function() {this.onchange = null});
		$("input").attr("disabled", "disabled");
		$("select").attr("disabled", "disabled");
		
		$(".badge").each(function() {this.innerHTML = "graded"});

		$("#main_message").append('<div class="alert alert-block alert-info"><a class="close" data-dismiss="alert" href="#">×</a><b>This was already graded</b>, no more changes are possible.</div>');
	    }
	}
    });
});
</script>
<script>var actual_answers=[];</script>

<script>comments={ "missing": "Missing answer","correct": "Correct answer","incorrect": "Incorrect answer" };</script>
