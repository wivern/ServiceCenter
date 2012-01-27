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
        var bbar = this.getDockedItems('pagingtoolbar')[0];
        var createFrom = bbar.child('button[name=createFrom]');
        var me = this;
        createFrom.menu.items.each(function(i){
           console.debug(i);
            i.on('click', me.onCreateOrderFrom, me);
        });
//        Ext.each(createFrom.menu.items, function(c){
//            console.debug(c);
//            if (c)
//                c.on('click', this.onCreateOrderFrom);
//        });
        this.getSelectionModel().on('selectionchange', function(selModel, selected){
           var disabled = selected.length === 0;
           if (!disabled && selected[0].isNew) disabled = true;
           this.actions.open.setDisabled(disabled);
           var bbar = this.getDockedItems('pagingtoolbar')[0];
           bbar.child('button[name=createFrom]').setDisabled(disabled);
           bbar.child('button[name=print]').setDisabled(disabled);
        }, this);
        //create_from menu
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
    onCreateOrderFrom:function(item, e){
        console.debug('create from', item);
        var me = this;
        var selection = this.getView().getSelectionModel().getSelection();
        if (selection.length > 0){
            var order = selection[0];
            Ext.MessageBox.show({
                title: me.i18n.confirmation,
                msg: 'Вы согласны создать заказ на основании выбранного?',
                buttons: Ext.MessageBox.YESNO,
                icon: Ext.MessageBox.QUESTION,
                fn: function(btn){
                    if (btn === 'yes'){
                       console.debug('create from', order);
                       me.createFrom({
                           order_id: order.get('id'),
                           repair_type_id: item.repairType
                       });
                    }
                }
            });
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