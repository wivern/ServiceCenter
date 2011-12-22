/**
 * User: vitaly
 * Date: 21.12.11
 * Time: 10:42
 */
{
    initComponent: function(){
        this.callParent();
        var win = this.getChildNetzkeComponent(this.id + '__select_spare_part');
        console.debug('Searching', this.id + '__select_spare_part');
        if (win){
            console.debug('found', win);
            win.on('partsadded', function(){
                this.store.load();
            }, this);
        }
    },
    onAddInline: function(){
       if (!this.selectPartWindow){
          this.loadNetzkeComponent({
                  name: 'select_spare_part',
                  callback: function(comp){
                      this.selectPartWindow = comp;
                      comp.show();
                      comp.on('partsadded', function(){
                         this.store.load();
                      }, this);
                  }
              }
          );

       } else this.selectPartWindow.show();
       this.selectPartWindow.show();
    },
    normalizeAssociationRenderer: function(c) {
      c.scope = this;
      var passedRenderer = c.renderer; // renderer we got from normalizeRenderer
          c.renderer = function(value, a, r, ri, ci){
            var column = this.headerCt.items.getAt(ci),
               editor = column.getEditor && column.getEditor(),
                // HACK: using private property 'store'
              recordFromStore = editor && editor.isXType('selecttriggerfield') &&
                    editor.store.findRecord(editor.store.valueField, value),
                renderedValue;
            if (editor.store){
                console.debug('store', editor.store.data);
                console.debug('find',editor.store.findRecord(editor.store.valueField, value));
            }
            if (recordFromStore) {
              renderedValue = recordFromStore.get(editor.store.displayField);
            } else if (c.assoc && r.get('_meta')) {
              renderedValue = r.get('_meta').associationValues[c.name] || value;
            } else {
              renderedValue = value;
            }
            return passedRenderer ? passedRenderer.call(this, renderedValue) : renderedValue;
          };
      }
}