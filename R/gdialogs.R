
##' @include gcomponent.R
NULL

## helper to format messasge with detail
.make_message <- function(msg) {
  if(length(msg) > 1)
    msg <- sprintf("<b>%s</b><br/>%s",
                   msg[1],
                   paste(msg[-1], collapse="<br/>")
                   )
  escape_single_quote(msg)
}

##' A simple message dialog.
##' 
##' @param message main message.
##' @param title Title for dialog's window
##' @param icon icon to decorate dialog. One of \code{c("info", "warning", "error", "question")}.
##' @param parent ignored
##' @param ... ignored
##' @return return value ignored
##' @export
##' @examples
##' w <- gwindow()
##' gbutton("click me for a message", cont=w, handler=function(h,...) {
##' gmessage("Hello there", parent=w)
##' })
gmessage <- function(message, title="message",
                     icon = NULL,
                     parent = NULL,
                     ...) {

 
  
  icon <- sprintf("Ext.MessageBox.%s", toupper(match.arg(icon,c("info", "warning", "error", "question"))))

  tpl <- "
Ext.Msg.show({
  title:'{{title}}',
  msg:'{{message}}',
  buttons:Ext.Msg.CANCEL,
  icon:{{icon}},
  animEl:'{{parent_id}}'
});
"
  cmd <- whisker.render(tpl,
                        list(title=escape_single_quote(title),
                             message=.make_message(message),
                             icon=icon,
                             parent_id="gWidget_toplevel")
                        )
  push_queue(cmd)
}


##' Confirmation dialog
##'
##' Calls handler when Yes button is clicked. Unlike other gWidgets
##' implementations, this one does not block the R process before
##' returning a logical indicating the selection. One must use a
##' handler to have interactivity.
##' @param message message
##' @param title title for dialog's window
##' @param icon icon. One of 'info', 'warning', 'error', or 'question'.
##' @param parent ignored
##' @param handler handler passed to dialog if confirmed
##' @param action passed to any handler
##' @param ... ignored
##' @return return value ignored, use handler for response.
##' @export
##' @examples
##' w <- gwindow()
##' gbutton("click me for a message", cont=w, handler=function(h,...) {
##' gconfirm("Do you like R", parent=w, handler=function(h,...) {
##' galert("Glad you do", parent=w)
##' })
##' })
gconfirm <- function(message, title="Confirm",
                     icon = NULL,
                     parent = NULL,
                     handler = NULL,
                     action = NULL,...) {
  obj <- new_item()
  class(obj) <- c("GConfirm", "GDialog", "GComponent", class(obj))

  add_handler(obj, "dialog", handler, action)
    
  tpl <- "
Ext.Msg.show({
  title:'{{title}}',
  msg:'{{message}}',
  buttons:Ext.Msg.YESNO,
  icon:Ext.MessageBox.{{icon}},
  animEl:'gWidget_toplevel',
  fn:function(buttonID, text, o) {
    if(buttonID == 'yes') {
      call_r_handler('{{id}}', 'dialog')
    }
  }
});
"
  cmd <- whisker.render(tpl,
                        list(title=escape_single_quote(title),
                             message=.make_message(message),
                             icon=toupper(match.arg(icon,c('info', 'warning', 'error', 'question'))),
                             id=obj
                             ))
  push_queue(cmd)
}



             
##' input dialog.
##'
##' Used for getting a text string to pass to a handler. Unlike other
##' gWidgets implementations, this call does not block the R process,
##' so any response to the user must be done through the handler.
##' @param message message
##' @param text initial text for the widget
##' @param title title for dialog's window
##' @param icon icon ignored here
##' @param parent ignored
##' @param handler Called if yes is selected, the component
##' \code{input} of the first argument holds the user-supplied string.
##' @param action passed to any handler
##' @param ... ignored
##' @return return value ignored, use handler for response
##' @export
##' @examples
##' w <- gwindow()
##' gbutton("click me for a message", cont=w, handler=function(h,...) {
##'   ginput("What is your name?", parent=w, handler=function(h,...) {
##'     galert(paste("Hello", h$input), parent=w)
##'   })
##' })
ginput <- function(message, text="", title="Input",
                   icon = NULL,
                   parent=NULL,
                   handler = NULL, action = NULL,...) {

  obj <- new_item()
  class(obj) <- c("GConfirm", "GDialog", "GComponent", class(obj))
  
  add_handler(obj, "dialog", handler, action)
  
  
  fn <- paste("function(buttonID, text) {",
              "if(buttonID == 'ok') {",
              sprintf("call_r_handler('%s', 'dialog',  {input:text})",
                      obj), 
              "}}",
              sep="")
                             
                                  
  cmd <- sprintf("Ext.Msg.prompt('%s','%s', %s, this, true, '%s');",
                 escape_single_quote(title),
                 .make_message(message),
                 fn,
                 escape_single_quote(text)
                 )
  push_queue(cmd)
}

## galert -- needs Ext.example and its css
