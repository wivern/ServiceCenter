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
//            Ext.MessageBox.alert('Заказ',
//                'Заказ создан успешно, № заказа ' + number + ', № квитанции ' + ticket +'.',
//                function(){
//                    self.getForm().getFields().each(function(item){
////                        if (item.name == 'applied_at')
////                            item.setValue(new Date());
////                        else
////                            item.setValue(null);
//                    });
//                }
//            );
        }, this);
        this.callParent(arguments);
    }

}