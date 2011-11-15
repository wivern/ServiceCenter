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
        var app = Ext.ComponentQuery.query('viewport')[0];
        app.selectOrder({order_id: recordId});
        app.appLoadComponent('order_details');
    },
    selModel:{
      singleSelect: true
    },
    viewConfig:{
        listeners:{
            itemdblclick: function(dataview,record,item,index,e){
                console.debug('dblclick', record);
                var orderId = record.get('id');
                if (orderId){
                    dataview.openOrderDetails(orderId);
                    e.stopPropagation();
                }
            }
        }
    }
}