/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 15.11.11
 * Time: 15:43
 */

{
    defaults: {
        readOnly: true
    },
    initComponent: function(){
        this.callParent();
        Ext.each(this.columns, function(c){
            if (!c.meta)
                c.editable = false;
        });
        this.getSelectionModel().on('selectionchange', function(selModel, selected){
           var disabled = selected.length === 0;
           if (!disabled && selected[0].isNew) disabled = true;
           this.actions.open.setDisabled(disabled);
           this.actions.print.setDisabled(disabled);
        }, this);
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
    onOpen: function(){
       if (this.getView().getSelectionModel().getSelection().length > 0){
           this.getView().openOrderDetails(this.getView().getSelectionModel().getSelection()[0]);
       }
    },
    viewConfig:{
        openOrderDetails: function(record){
            var app = Ext.ComponentQuery.query('viewport')[0],
                orderId = record.get('id'),
                number = record.get('number');
            app.selectOrder({order_id: orderId});
            app.addTab('OrderDetailsPanel',{
                config:{
                    record_id: orderId,
                    title: 'Заказ № ' + number
                }
            });
//            app.appLoadComponent('order_details');
        }
    }
}