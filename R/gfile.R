##' @include gcomponent.R
NULL

##' File selection form
##'
##' This renders a file selection form within a small panel
##' widget. There are two steps needed to transfer a file: a) select a
##' file through a dialog, b) save the file to the server by clicking
##' the upload button.
##'
##' When a file is uploaded, any change handlers are called.
##'
##' The \code{svalue} method gives the path of the uploaded file, the
##' \code{[} method gives the original name of the file when uploaded.
##' @param text Instructional text. 
##' @param type only "open" implemented
##' @param filter ignored
##' @inheritParams gwidget
##' @return a \code{GFile} instance
##' @note the \code{svalue} method returns the temporary filename of
##' the uploaded file, or a value of \code{""}. The \code{[} method
##' gives the original filename, once one is uploaded.
##' @export
##' @examples
##' w <- gwindow()
##' gstatusbar("Powered by gWidgetsWWW2 and Rook", cont=w)
##' f <- gfile("Choose a file for upload", cont=w, handler=function(h,...) {
##'   galert(paste("You uploaded", svalue(h$obj)), parent=w)
##' })
gfile <- function(text="Choose a file",
                  type = c("open"),
                  filter = NULL, 
                  handler = NULL, action = NULL, container = NULL, ...,
                  width=NULL, height=NULL, ext.args=NULL,
                  fieldlabel=NULL,      # label for upload form
                  placeholder=gettext("Select a file..."),
                  upload.message=gettext("Uploading your file ...")
                  ) {


  obj <- new_item()
  class(obj) <- c("GFile", "GWidget", "GComponent", class(obj))
  
  ## vals
  set_vals(obj, value="")

  
  ## could put in list form, but we don't...
  tpl <- "
var ogWidget_{{{obj}}} = Ext.create('Ext.form.Panel', {
        frame: true,
        bodyPadding: '10 10 0',

        defaults: {
            anchor: '100%',
            allowBlank: false,
            msgTarget: 'side',
            labelWidth: 50
        },

        items: [{
            xtype: 'filefield',
            id: 'form-file',
            emptyText: '{{placeholder}}',
            {{#fieldlabel}}fieldLabel: '{{fieldlabel}}',{{/fieldlabel}}
            name: 'file-path',
            buttonText: 'Browse...'
        }],

        buttons: [{
            text: 'Upload file...',
            iconCls: 'x-gw-icon-upload',
            handler: function(){
                var form = this.up('form').getForm();
                if(form.isValid()){
                    form.submit({
                        url: 'file_upload', 
                        params:{ID:ID, obj:'{{{obj}}}' },
                        waitMsg: '{{upload.message}}',
                        success: function(fp, o) {
                            call_r_handler('{{{obj}}}', 'upload');
                        }
                    });
                }
            }
        }]
    });
"

  url_base <- make_url(""); "/custom/gw"              # replace me!!!
  push_queue(whisker.render(tpl))

  
  ## add
  add(container, obj, ...)

  
  ## handlers
  if(!missing(handler)) 
    addHandlerChanged(obj, handler, action)

  obj
}
  
addHandlerChanged.GFile <- function(obj, handler, action=NULL, ...) {
  message("add upload handler for gfile")
  addHandler(obj, "upload", handler, action, ...)
}


"[.GFile" <- function(x, ...) get_items(x)
