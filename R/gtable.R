##' @include gcomponent.R
NULL

## TODO: icons, dates, visible!, transport, handler, paging, infinite scrolling, ...

##' gtable
##'
##' @export
gtable <- function(items, multiple=FALSE,
                   icon.FUN=NULL, handler, action=NULL,
                   container, ...,
                   width, height, ext.args, paging, col.widths=1) {

  obj <- new_item()
  class(obj) <- c("GTable", "GWidgetArrayProxy", "GWidget", "GComponent", class(obj))

  ## vals
  f <- tempfile(fileext=".data")
  if(!missing(items))
    write.table(items, file=f)
  
  set_vals(obj,
           value=1,
           items=f,
           properties=list(multiple=multiple, chosencol=1))

  
  ## js. Need both a store and a panel
  store_constructor <- shQuote("Ext.data.Store")
  oid <- o_id(obj)
  
  tpl <- '
var {{{oid}}}_store = Ext.create({{{store_constructor}}},{{{store_args}}});'

  store_args <- list(fields=names(items), # problem if ncol=1?
                     proxy=list(
                       type="ajax",
                       extraParams=list(ID=I("ID"), obj=as.character(obj)),
                       url="/custom/gw/proxy_call",
                       reader=list(type="json")
                       ),
                     autoLoad=TRUE,
                     paging=TRUE,
                     page_size=200L
                     )
  store_args <- list_to_object(store_args)

  push_queue(whisker.render(tpl))


  constructor <- "Ext.grid.Panel"
  args <- list(store=I(paste(oid, "store", sep="_")),
               columns=make_columns(items, col.width=1),
               frame=FALSE,
               stripeRows=TRUE)
  args <- merge_list(args, ext.args, add_dots(obj, ...))
  push_queue(write_ext_constructor(obj, constructor, args))
               
  ## add
  add(container, obj, ...)
  
  ## need transport
  
  ## handlers
  if(!missing(handler)) {
    signal <- "selectionchange"
    addHandler(obj, signal, handler, action=action)

    tpl <- '
ogWidget_{{obj}}.on("{{signal}}", function(e, opts) {
  
  Ext.Ajax.request({
    url:"/custom/gw/ajax_call",
    params:{ID:ID,obj:"{{obj}}", signal:"{{signal}}"},
    success:function(response) {
              eval(response.responseText);
              console.log("ajax call done");
            }
  });
});
'
    push_queue(whisker.render(tpl))

  }

  obj
}


## return pasted together columns object
make_columns <- function(items, col.widths=1) {
  f <- function(name="", width=1) {
    l <- list(text=name, dataIndex=name, flex=width)
    toJSON(l, collapse="")
  }
  out <- mapply(f, name=names(items), width=col.widths, SIMPLIFY=FALSE)
  I(sprintf("[%s]", paste(out, collapse=",")))
}
  
  



"[<-.GWidgetArrayProxy" <- function(x, i,j,..., value) {
  f <- get_vals(x, "items")
  write.table(value, file=f)

  ## need to call load
  tpl <- "
ogWidget_{{x}}_store.load({{#params}} {params:{{{params}}} } {{/params}});
"
  push_queue(whisker.render(tpl))

  x
}
