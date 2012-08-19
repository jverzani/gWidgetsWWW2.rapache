### This is how we can resize canvas object. Don't like it.
## http://stackoverflow.com/questions/7966038/extjs-panel-resizer-after-resize
## we roll our own template here
  tpl <- '
var {{{oid}}} = Ext.create("Ext.Panel", {
  border:false,
  html:"<canvas id=\'{{{oid}}}_canvas\' style=\'position:"absolute"\'>no canvas tag for this browser</canvas>"
  });
  {{{oid}}}_resizer = Ext.create("Ext.resizer.Resizer", {
  target:{{{oid}}},
  minWidth:{{{width}}},
  minHeight:{{{height}}},
  pinned:true
});
'

##style=\\\'position:\"absolute\"\\\'  

tpl <- "
var {{{oid}}} =   new Ext.Panel({
    width: {{{width}}},
    height: {{{height}}},
    html:'<canvas id=\"{{{oid}}}_canvas\">no canvas tag for this browser</canvas>',
    listeners: {
        render: function(p) {
            new Ext.Resizable(p.getEl(), {
                animate: true,
                duration: '.6',
                easing: 'backIn',
                handles: 'all',
                pinned: false,
                transparent: true,
                resizeElement: function() {
                    var box = this.proxy.getBox();
                    if (this.updateBox) {
                        this.el.setBox(
                        box, false, this.animate, this.duration, function() {
                            p.updateBox(box);
                            if (p.layout) {
                                p.doLayout();
                            }
                        }, this.easing);
                    } else {
                        this.el.setSize(
                        box.width, box.height, this.animate, this.duration, function() {
                            p.updateBox(box);
                            if (p.layout) {
                                p.doLayout();
                            }
                        }, this.easing);
                    }
                    this.updateChildSize();
                    if (!this.dynamic) {
                        this.proxy.hide();
                    }
                    if (this.draggable && this.constrainTo) {
                        this.dd.resetConstraints();
                        this.dd.constrainTo(this.constrainTo);
                    }
                    return box;
                }
            });
        }
    }
});
"
  oid <- o_id(obj)
  width <- width %||% 480
  height <- height %||% 400

  push_queue(whisker.render(tpl))

