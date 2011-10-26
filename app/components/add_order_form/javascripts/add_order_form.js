{
    initComponent: function(){
        this.on('submitsuccess', function(){
           console.debug('submit success');
            var number = this.getForm().findField('number').getValue();
            var ticket = this.getForm().findField('ticket').getValue();
            Ext.MessageBox.alert('Заказ',
                'Заказ создан успешно, № заказа ' + number + ', № квитанции ' + ticket +'.',
                function(){
                    this.getForm().reset();
                }
            );
        }, this);
        this.callParent(arguments);
    }
}