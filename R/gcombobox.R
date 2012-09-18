##' @include gcomponent.R
##' @include gtable.R
NULL

##' comobobox
##'
##' @export
gcombobox <- function(items, selected=1, editable=FALSE, coerce.with=NULL,
           handler = NULL, action = NULL, container=NULL,...,
                      width=NULL,
                      height=NULL,
                      ext.args=NULL,
                      autocomplete=FALSE,
                      initial.msg="",
                      tpl=NULL
                      ) {


   
  obj <- new_item()
  class(obj) <- c("GCombobox", "GWidgetArrayProxy", "GWidget", "GComponent", class(obj))


  f <- tempfile(fileext=".data")
  items <- .normalize_combobox_items(items)
  write.table(items, file=f)
  
  ## vals
  set_vals(obj, value="",
           items=f,
           properties=list(editable=editable, coerce.with=coerce.with))
  
  ## js
  store_constructor <- shQuote("Ext.data.Store")
  oid <- o_id(obj)
  
  
  ## make a store
  tmpl <- '
var {{{oid}}}_store = Ext.create({{{store_constructor}}},{{{store_args}}});'

  store_args <- list(fields=names(items), # problem if ncol=1?
                     proxy=list(
                       type="ajax",
                       extraParams=list(ID=I("ID"), obj=as.character(obj)),
                       url=make_url("proxy_call"), ##"/custom/gw/proxy_call",
                       reader=list(type="json")
                       ),
                     autoLoad=TRUE
                     )

  if(selected >= 1) {
    val <- items[selected, 1, drop=TRUE]
    set_value(obj, val)

    if(!is.numeric(val)) val <- shQuote(val)
    ## must put in to load listener. Don't like this, as what happens when we
    ## reload data?
    store_args$listeners=I(whisker.render("{
load: function() {
  {{{oid}}}.setValue({{{val}}});
}}"))
  }
  store_args <- list_to_object(store_args)
  push_queue(whisker.render(tmpl))

  ## make widget
  if(is.null(tpl))
    tpl <- .make_tpl(items)
  
  tpl <- sprintf("Ext.create('Ext.XTemplate','<tpl for=\".\"><div class=\"x-boundlist-item\">%s</div></tpl>')", tpl)

  get_class_stupid <- function(x) {
    if(is.numeric(x))
      I(x)
    else
      x
  }
  
  ## cf., http://skirtlesden.com/articles/extjs-comboboxes-part-1
  constructor <- "Ext.form.field.ComboBox"
  args <- list(store=I(paste(oid, "store", sep="_")),
               displayField="value",
#               value=if(selected >= 1) get_class_stupid(items[selected,1, drop=TRUE]) else NULL,
               tpl=I(tpl),
               minChars=1,
               forceSelection=!editable,
               growToLongestValue=TRUE,
               typeAhead=TRUE,
               width=width,
               height=height
               )
  
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))

  ## add
  add(container, obj, ...)

  ## need to call this after proxy loads data, but
  ## don't have such a signal defined
  ## if(selected >= 1) {
  ##   gtimer(300, function(...) 
  ##          svalue(obj) <- items[selected, 1, drop=TRUE],
  ##          one.shot=TRUE)
  ## }

  
  ## handlers
  transport <- function(h,...) {}
  addHandlerChanged(obj, transport)
  
  if(!missing(handler)) 
    addHandlerChanged(obj, handler, action)

  
  obj
}

##
set_value_js.GCombobox <- function(obj,  value) {
  if(!is.na(value) && length(value) && nchar(value)) {
    if(!is.numeric(value))
      value <- shQuote(value)
    call_ext(obj, "setValue", value)
  } else {
    call_ext(obj, "setValue", "")
  }
}




# handlers
before_handler.GCombobox <- function(obj, signal, params, ...) {
  message("before handler:", capture.output(params))
  set_vals(obj, value=params$value)
}

addHandlerChanged.GCombobox <- function(obj, handler, action=NULL, ...) {
  if(get_vals(obj, "properties")$editable) {
    addHandlerChange(obj, handler, action)
  } else {
    addHandlerSelect(obj, handler, action)
  }
}
              

addHandlerBlur.GCombobox <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "blur", handler, action, ...,
             params="var params = {value: this.getRawValue()};"
             )
}

addHandlerChange.GCombobox <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "change", handler, action, ...,
             params="var params = {value: this.getRawValue()};"
             )
}

addHandlerSelect.GCombobox <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "select", handler, action, ...,
             params="var params = {value: this.getRawValue()};"
             )
}

## return data frame with values: icon, value, tooltip?, ...
.normalize_combobox_items <- function(items) {
   if(!is.data.frame(items)) {
     items <- data.frame(value=items, label=items, stringsAsFactors=FALSE)
   }
#   items[[1]] <- as.character(items[[1]]) # name is character
   ## standardize first three names
   nms <- c("value", "label", "icon", "tooltip")
   nc <- ncol(items)
   mnc <- min(4, nc)
   names(items)[1:mnc] <- nms[1:mnc]
   
   
   items
}

.make_tpl <- function(items) {
  "Make template to match standard names: value, label, icon, tooltip"
  if(ncol(items) ==2)
    '{label}'
  else if(ncol(items) ==2)
    '<span class="x-gw-icon-{icon}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>{label}'
  else
    '<span class="x-gw-icon-{icon}">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span data-qtip="{tooltip}">{label}</span>'
}
