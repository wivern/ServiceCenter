{
    initComponent: function(){
        this.on('submitsuccess', function(){
           console.debug('submit success');
            var self = this;
            var number = this.getForm().findField('number').getValue();
            var ticket = this.getForm().findField('ticket').getValue();
            Ext.MessageBox.alert('Заказ',
                'Заказ создан успешно, № заказа ' + number + ', № квитанции ' + ticket +'.',
                function(){
                    self.getForm().getFields().each(function(item){
                        if (item.name == 'applied_at')
                            item.setValue(new Date());
                        else
                            item.setValue(null);
                    });
                }
            );
        }, this);
        this.callParent(arguments);
    }
}