{
    initComponent: function(){
        var self = this;
        this.on('submitsuccess', function(){
            var self = this;
            console.debug('submit success', self);
            var number = this.getForm().findField('number').getValue();
            var recordId = this.getForm().findField('recordId').getValue();
            var app = Ext.ComponentQuery.query('viewport')[0];
            app.selectOrder({order_id: recordId});
            app.addTab('OrderDetailsPanel', {
               config:{
                   record_id: recordId,
                   title: "Заказ № " + number
               }
            });
//            app.appLoadComponent('order_details');
            this.getForm().reset();
            var appliedAt = this.getForm().findField("appliedAt"),
                today = Ext.Date.now();
            if (appliedAt){
                appliedAt.setValue(today);
                var deliverAt = this.getForm().findField("planDeliverAt");
                if (deliverAt){
                    deliverAt.setValue(Ext.Date.add(today,14));
                }
            }
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
    },
    onApply: function(){
        if (this.fireEvent('apply', this)) {
            var values = this.getForm().getValues();
            //filter readonly fields
            for(var fieldName in values){
                var field = this.getForm().findField(fieldName);
                if (!field || field.disabled)
                    delete values[fieldName];
                else if (field && field.name.indexOf("__") !== -1 && field.readOnly && !field.nestedAttribute)
                    delete values[fieldName];
                else if (field && field.isXType("displayfield"))
                    delete values[fieldName];
                else if (field && field.displayOnly)
                    delete values[fieldName];
            }
            if (this.fileUpload) {
                    this.getForm().submit({ // normal submit
                      url: this.endpointUrl("netzke_submit"),
                      params: {
                        data: Ext.encode(values) // here are the correct values that may be different from display values
                      },
                      failure: function(form, action){
                        if (this.applyMaskCmp) this.applyMaskCmp.hide();
                      },
                      success: function(form, action) {
                        try {
                          var respObj = Ext.decode(action.response.responseText);
                          delete respObj.success;
                          this.bulkExecute(respObj);
                          this.fireEvent('submitsuccess');
                        }
                        catch(e) {
                          Ext.Msg.alert('File upload error', action.response.responseText);
                        }
                        if (this.applyMaskCmp) this.applyMaskCmp.hide();
                      },
                      scope: this
                    });
                  } else {
                    this.netzkeSubmit(Ext.apply((this.baseParams || {}), {data:Ext.encode(values)}), function(success){
                      if (success) {
                        this.fireEvent("submitsuccess");
                        if (this.mode == "lockable") this.setReadonlyMode(true);
                      };
                      if (this.applyMaskCmp) this.applyMaskCmp.hide();
                    }, this);
                  }
        }
    }

}