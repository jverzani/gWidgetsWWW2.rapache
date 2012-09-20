tree; 
ex- link to roxygen; 
demos;
*rook front; 
* export methods (manipulate example!)
DONE ** checkbox selection model; 
DONE * about; 

some way to access data set (gdata(mtcars, type="csv"), then call_r_handler(obj, "data")... used with gpanel.. 
TEST gaction, gmenu, gbutton + gaction
gtext TRANSPORT, insert (can do)

DONE * change_favicon

Containers
-----------
DONE * test gborderlayout
* for now, no glayout or gpanedgroup
DONE * border in vbox?
DONE * gnotebook
DONE * gstackwidget


Widgets
-------
* ghtml needs svalue method
* gpanel?
* gtree
* ggooglemaps
* gtext: issue with escaping quotes?
* widget for dnd reordering? Use case?
ISSUE * gdf, editing a data frame? Not as critical as uploading data
DONE * checkbox table: actiongroup? also drag and drop rows?
DONE * gtable handlers, multiple selection, icon+tooltip column
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

Exmaples to write
-------
DONE * about
DONE * handlers
DONE * manipuate
* timers
* tables (DONE filter, ...)


Graphics
--------
DONE * canvas
DONE* svg (d3?)
DONE * images

Plumbing
--------
* gfile can limit size with apache configuration, but can't make graceful via callback
DONE * static files, temp_urls, ... (not needed!)
DONE * need to limit serach for scripts (script_base=c("example_dir", "/tmp", ...)) i.e. relative to this
DONE * clean_up being called?
DONE * stock icons are slow (.3sec. could cache, could use urls...) (moved to file, load with static_... need to cache)
DONE * handlers: block/unblock all for obje
DONE * rename gWidgetsWWW2.rapache
DONE * get_id from data base, not ..id..



