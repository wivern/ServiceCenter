/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 15.11.11
 * Time: 15:43
 */

{
    defaults: {
        editable: false
    },
    openOrderDetails: function(orderId){
        this.getView().openOrderDetails(orderId);
    },
    selModel:{
      mode: 'SINGLE'
    },
    listeners:{
      selectionchange: function(view, selections, options){
          var bbar = this.getDockedItems('pagingtoolbar')[0];
          console.debug(bbar);
          if (bbar){
            var pbutton = bbar.child('button[name=print]');
            if (selections[0]){
                this.loadPrintButtonOptions(pbutton, selections[0].get('id'));
            }
          }
      }
    },
    viewConfig:{
        openOrderDetails: function(orderId){
            var app = Ext.ComponentQuery.query('viewport')[0];
            app.selectOrder({order_id: orderId});
            app.appLoadComponent('order_details');
        },
        listeners:{
            itemdblclick: function(dataview, record, item, index, e){
                console.debug('dblclick', dataview);
                var orderId = record.get('id');
                if (orderId){
                    dataview.openOrderDetails(orderId);
                    e.stopPropagation();
                }
            }
        }
    }
}