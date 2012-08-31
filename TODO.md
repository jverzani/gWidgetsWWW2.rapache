some way to access data set (gdata(mtcars, type="csv"), then call_r_handler(obj, "data")... used with gpanel.. 
TEST gaction, gmenu, gbutton + gaction
gtext TRANSPORT, insert (can do)
Containers
-----------
DONE * test gborderlayout
* for now, no glayout or gpanedgroup
DONE * border in vbox?
DONE * gnotebook
DONE * gstackwidget


Widgets
-------
* gtable: icons, drag and drop reordering (make for checkbox?)

* gtable handlers, multiple selection, icon+tooltip column
* checkbox table: actiongroup? also drag and drop rows?
* icons in gtable, ..
* editing a data frame? Not as critical as uploading data
* gtree
* ggooglemaps
* gtext: issue with escaping quotes?
DONE * gfile 
DONE * galert 
DONE * gpanel
DONE * gaction
DONE * gtoolbar
DONE * test gradio
DONE* slider, spinbox (Numeric)
DONE * gradio, gcheckboxgroup setting names
DONE * gcheckboxgroup with gcheckbox as a specialization
DONE * form stuff labels, ... no resizing of radio, checkboxgroup, .., but we should implement names<-, length

DialogsXbgcan
-------


Graphics
--------
DONE * canvas
DONE* svg (d3?)
DONE * images

Plumbing
--------
DONE * static files, temp_urls, ...
DONE * need to limit serach for scripts (script_base=c("example_dir", "/tmp", ...)) i.e. relative to this
DONE * clean_up being called?
DONE * stock icons are slow (.3sec. could cache, could use urls...) (moved to file, load with static_... need to cache)
DONE * handlers: block/unblock all for obje
DONE * rename gWidgetsWWW2.rapache
DONE * get_id from data base, not ..id..



