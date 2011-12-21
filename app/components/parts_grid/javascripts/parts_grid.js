/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 21.12.11
 * Time: 10:42
 * To change this template use File | Settings | File Templates.
 */
{
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