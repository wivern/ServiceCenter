/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 03.02.12
 * Time: 13:45
 * To change this template use File | Settings | File Templates.
 */


{
    bodyStyle     : 'padding: 5px 5px 0',
    autoScroll    : true,
    fieldDefaults : { labelWidth : 120 },
    applyMask     : { msg: "Применяется..." },

    initComponent: function(){
        this.callParent(arguments);
//        this.addEvents('applysuccess');
    },
    onApply: function(){
        var values = this.getForm().getValues();
        this.netzkeSubmit(Ext.apply((this.baseParams || {}), {data:Ext.encode(values)}), function(success){
            if (this.applyMaskCmp) this.applyMaskCmp.hide();
            this.fireEvent('submitsuccess');
        }, this);
    }
}