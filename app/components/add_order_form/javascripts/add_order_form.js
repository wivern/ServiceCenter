{
    initComponent: function(){
        this.on('submitsuccess', function(){
           console.debug('submit success');
            var self = this;
            var number = this.record.number; //this.getForm().findField('number').getValue();
            var recordId =  this.record.id;//this.getForm().findField('recordId').getValue();
            var app = Ext.ComponentQuery.query('viewport')[0];
            app.selectOrder({order_id: recordId});
            app.appLoadComponent('order_details');
        }, this);
        console.debug(this);

        this.callParent(arguments);

        var producerField = this.getForm().findField('product_passport__producer__name');
        if (producerField)
            producerField.on('change', function(field, newValue, oldValue, opts){
                console.debug('producer changed', newValue);
                this.selectProducer({producer: newValue});
                var win = this.getChildNetzkeComponent('select_product_window');
                if (win){
                    var grid = win.items.first();
                    if (grid) grid.getStore().load();
                }
                console.debug('change handler finished');
            }, this);
        else
            console.debug('field not found');
    }

}