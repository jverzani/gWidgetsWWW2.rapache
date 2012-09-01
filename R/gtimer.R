##' @include gcomponent.R
NULL

##' Basic timer widget
##'
##' Calls FUN every ms/1000 seconds.
##' @param ms interval in milliseconds
##' @param FUN Function to call. Has one argument, data passed in
##' @param data passed to function
##' @param one.shot logical. If TRUE, called just once, else repeats
##' @param toolkit gui toolkit to dispatch into
##' @export
##' @rdname gtimer
gtimer <- function(ms, FUN, data=NULL,  one.shot=FALSE, start=TRUE, toolkit=guiToolkit()) {


  obj <- new_item()
  class(obj) <- c("GTimer", "GWidget", "GComponent", class(obj))

one_shot_tpl <- "
var {{{oid}}} = new Ext.util.DelayedTask(function(){
    call_r_handler('{{{obj}}}', 'call-timer');
});
  {{{oid}}}.delay({{ms}});
"

task_tpl <- "
var {{{oid}}}_task = {
  run: function() {call_r_handler('{{{obj}}}', 'call-timer')},
  interval:{{{ms}}}
}
var {{{oid}}} = new Ext.util.TaskRunner();
{{{oid}}}.start({{{oid}}}_task);
"

  tpl <- ifelse(one.shot, one_shot_tpl, task_tpl)
  oid <- o_id(obj)
  push_queue(whisker.render(tpl))
  
  handler <- function(h,...) {
    FUN(h$action)
  }

  ## add to queue, not JS though
  add_handler(obj, "call-timer", handler, action=data)

  obj
}

start_timer <- function(obj) {
  oid <- o_id(obj)
  call_ext(obj, "start", whisker.render("{{{oid}}}_task"))
}

stop_timer <- function(obj) {
  oid <- o_id(obj)
  call_ext(obj, "stop", whisker.render("{{{oid}}}_task"))
}
