##' @include gcomponent.R
NULL

## TODO: icons, dates, visible!, transport, handler, paging, infinite scrolling, ...

##' gtable
##'
##' @export
gtable <- function(items, multiple=FALSE, chosencol = 1,
                   icon.col = NULL,
                   tooltip.col=NULL,
                   handler=NULL, action=NULL,
                   container, ...,
                   width=NULL, height=NULL, ext.args=list(), store.args=list(),
                   selection=TRUE,      # FALSE for infinite scroll
                   paging=NULL,         # a number (pageSize) or NULL
                   col.widths=1         # flex value for columns, recycled
                   ) {

  obj <- new_item()
  class(obj) <- c("GTable", "GWidgetArrayProxy", "GWidget", "GComponent", class(obj))

  ## vals
  f <- tempfile(fileext=".data")
  if(!missing(items)) {
    if(any(grepl("\\.", names(items))))
      names(items) <- gsub("\\.", "_", names(items))
    write.table(items, file=f)

  }
  
  set_vals(obj,
           value=0,
           items=f,
           properties=list(multiple=multiple, chosencol=1))

  
  ## js. Need both a store and a panel
  store_constructor <- shQuote("Ext.data.Store")
  oid <- o_id(obj)
  
  tpl <- '
  var {{{oid}}}_store = Ext.create({{{store_constructor}}},{{{store_args}}});
  {{{oid}}}_store.getTotalCount = function() {return {{{nrows}}} };
'

  store_args <- list(fields=make_fields(items), # problem if ncol=1?
                     border=TRUE,
                     proxy=list(
                       type="ajax",
                       extraParams=list(ID=I("ID"), obj=as.character(obj)),
                       url="/custom/gw/proxy_call", # XXX
                       reader=list(type="json")
                       ),
                     autoLoad=TRUE,
                     pageSize=paging
                     )
  if(!selection) {
    store_args <- merge_list(store_args,
                             list(buffered=TRUE,
                                  leadingBufferZone=300L)
                             )
  }
  store_args <- merge_list(store_args, store.args)
  nrows <- nrow(items)
  
  store_args <- list_to_object(store_args)

  push_queue(whisker.render(tpl))

  ## panel
  constructor <- "Ext.grid.Panel"

  if(!selection)
    multiple <- NULL                    # no selection -> no multiple

  store_nm <- paste(oid, "store", sep="_")
  args <- list(store=I(store_nm),
               columns=make_columns(items, col.width=1),
               multiSelect=multiple,
               frame=FALSE,
               stripeRows=TRUE,
               width=width,
               height=height
               )

  if(!is.null(paging))                  # add toolbar if paging
    args$dockedItems <- I(whisker.render("[{
        xtype: 'pagingtoolbar',
        store: {{{store_nm}}},
        dock: 'bottom',
        displayInfo: true
    }]"))


  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))
               
  ## add
  add(container, obj, ...)
  
  ## need transport
  
  ## handlers
  addHandlerSelect(obj, function(...) {}) # transport
  if(!missing(handler)) {
    addHandlerChanged(obj, handler, action=action)

  ##   tpl <- '
## ogWidget_{{obj}}.on("{{signal}}", function(e, opts) {
  
##   Ext.Ajax.request({
##     url:"/custom/gw/ajax_call",
##     params:{ID:ID,obj:"{{obj}}", signal:"{{signal}}"},
##     success:function(response) {
##               eval(response.responseText);
##               console.log("ajax call done");
##             }
##   });
## });
## '
##     push_queue(whisker.render(tpl))

  }

  obj
}


## return pasted together columns object
make_columns <- function(items, col.widths=1) {
  f <- function(name="", x, width=1) {
    l <- list(text=name, dataIndex=name, flex=width,
              renderer=cell_renderer(x)
              )
    list_to_object(l)
  }
  out <- mapply(f, name=names(items), x=items, width=col.widths, SIMPLIFY=FALSE)
  I(sprintf("[%s]", paste(out, collapse=",")))
}

## return JavaScript array object with fields
make_fields <- function(items) {
  f <- function(nm, x) {
    list_to_object(list(name=nm, type=field_type(x)))
  }
  out <- mapply(f, names(items), items, SIMPLIFY=FALSE)
  out <- c(list_to_object(list(name="row_id", type="int")), out)
  I(sprintf("[%s]", paste(out, collapse=",")))
}

## might be best to default to "auto" then use the cell renderer, as o/w
## ExtJS converts our values and NAs get coerced.
field_type <- function(x) UseMethod("field_type")
field_type.default <- function(x) "auto"
## field_type.integer <- function(x) "auto" # int
## field_type.numeric <- function(x) "auto" # float
## field_type.character <- function(x) "auto"
## field_type.factor <- function(x) "auto"
## field_type.logical <- function(x) "boolean"
## field_type.Date <- function(x) "date"

## ## this is for gdf with new records
## ## default value for field type
## default_value <- function(x) UseMethod("default_value")
## default_value.default <- function(x) "NA"
## default_value.numeric <- function(x) NA

cell_renderer <- function(x) UseMethod("cell_renderer")
cell_renderer.default <- function(x) {
  tpl <- "function(value) {
var x = value == null ? 'NA' : Ext.String.format('{0}', value); return x;
}
"
  I(whisker.render(tpl))
}

## write JS to load store
load_store <- function(obj) {
  tpl <- "
  {{{oid}}}_store.getTotalCount = function() {return {{{len}}} };
  {{{oid}}}_store.load({{#params}} {params:{{{params}}} } {{/params}});
"

  len <- sum(visible(obj))              # default is all TRUE for visible()
  oid <- o_id(obj)
  push_queue(whisker.render(tpl))
}

## methods
gtable_delimiter <- "::--::" ## used with indices to sotre as string
svalue.GTable <- function(obj, index=NULL, drop=NULL, ...) {
  ## get selected
  index <- index %||% FALSE
  drop <- drop %||% TRUE

  sel <- get_value(obj)
  message("svalue gtable sel", sel)
  ## unslit
  ind <- strsplit(sel, gtable_delimiter)[[1]]

  if(index) {
    return(ind)
  } else {
    if(drop)
      obj[ind, get_property(obj, "chosencol"), drop=TRUE]
    else
      obj[ind, , drop=FALSE]
  }
}

"svalue<-.GTable" <- function(obj, index=NULL, ..., value) {
  ## we set by index
  index <- index %||% FALSE
  message("svalue value:", capture.output(print(value)))
  if(!index) {
    chosencol <- get_property(obj, "chosencol")
    value <- match(value, obj[, chosencol, drop=TRUE])
  }

  val <- paste(value, collapse=gtable_delimiter)
  message("set value:", val)
  set_value(obj, val)

  set_value_js(obj, svalue(obj, index=TRUE))
  

  obj
}

clear_selection <- function(obj) {
  cmd <- sprintf("%s.getSelectionModel().deselectAll()", o_id(obj))
  push_queue(cmd)
}

set_value_js.GTable <- function(obj, value) {
  ## value is vector of indices
  message("clear selection")
  clear_selection()
##   if(base:::length(value) == 0 ||
##      (base:::length(value) == 1 && is.na(value)) ||
##      value[1] <= 0) {
##     return()
##   }
##   ## else
##   tpl <- "
##   {{oid}}.getSelectionModel().selectRange({{start}},{{end}}, true);
## "
##   f <- function(start, end) {
##     cmd <- whisker.render(tpl, list(oid=o_id(obj),
##                                     start=start-1, end=end-1))
##     push_queue(cmd)
##   }
##   ## should figure out runs to shorten this
##   sapply(value, function(i) f(i,i))
}

## set values. We ignore i,j bit here
"[<-.GWidgetArrayProxy" <- function(x, i,j,..., value) {
  f <- get_vals(x, "items")
  write.table(value, file=f)

  vis <- visible(x)
  if(!is.null(vis) && length(vis) != nrow(value)) {
    vis <- rep(TRUE, length.out=nrow(value)) # all true if changing size
    update_property(x, "visible", vis)
  }
  ## need to call load, update totalCount
  load_store()

  x
}

## get values.
"[.GWidgetArrayProxy" <- function(x, i,j, ..., drop=TRUE) {
  f <- get_items(x)
  items <- read.table(f)

  items[i,j, ..., drop=drop]
}

visible.GTable <- function(obj) {
  vis <- get_property(obj, "visible")
  if(is.null(vis) || !is.logical(vis))
    vis <- rep(TRUE, length.out=nrow(obj[]))
  vis
}

"visible<-.GTable" <- function(obj, value) {
  items <- obj[,]
  value <- rep(value, length.out=nrow(items))
  update_property(obj, "visible", as.logical(value))

  load_store(obj)
  obj
}


dim.GTable <- function(x) dim(x[,])
length.GTable <- function(x) length(x[,])

## handlers

## we need to have this clear:
## Changed is to activate -- double click
## Select is single click and maps to svalue
## can't select when selection is NULL (but can infinite scroll)

before_handler.GTable <- function(obj, signal, params) {
  message("before handler signal:", signal)
  if(signal %in% c("selectionchange")) {
    ## XXX what to do?
    value <- paste(params$value, collapse=gtable_delimiter)
    message("before handler", value)
    set_value(obj, value)

  }

}

addHandlerChanged.GTable <- function(obj, handler, action=NULL, ...) {
  addHandlerDoubleclick(obj, handler, action, ...) 
}

#$(ogWidget_4.getSelectionModel().getSelection()).each(function() {console.log(this.get("row_id"))})
addHandlerSelect.GTable <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "selectionchange", handler, action, ...,
             params="var params={value:selected.map(function(rec) {return(rec.get('row_id'))})}"
             )
}

addHandlerClicked.GTable <- function(obj, handler, action=NULL, ...) {
  addHandler(obj, "cellclick", handler, action, ...,
             params="var params={row_index:rec.get('row_id'), column_index:cellIndex + 1}"
             )
}

addHandlerDoubleclick.GTable <- function(obj, handler, action=NULL, ...) {
  add_handler(obj, "celldblclick", ...,
              params="var params={row_index:rec.get('row_id'), column_index:cellIndex + 1}")
}

add_handler_column_clicked <- function(obj, ...) {
  add_handler(obj, "headerclick", ...,
              params="var params = {column_index:columnIndex + 1};"
              )
}

add_handler_column_double_click <- function(obj, ...) {
  add_handler(obj, "headerdblclick", ...,
              params="var params = {column_index:columnIndex + 1};"
              )
} 

## item click param = {value:rec.get('row_id')};
