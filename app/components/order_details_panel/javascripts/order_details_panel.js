/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 11.11.11
 * Time: 16:34
 * To change this template use File | Settings | File Templates.
 */
{
    afterRender: function(){
        this.callParent();

        if (this.record){
            this.updateToolbar();
            this.updateTitle();
        }
    },
    trackResetOnLoad: true,
    initialConfig:{
        trackResetOnLoad: true
    },
    updateTitle: function(){
        var number = this.record.number;
        this.setTitle('Карточка заказа № ' + number);
    },
    updateToolbar: function(){
        var tbar = this.child('toolbar');
        var pbutton = tbar.child('button[name=print]');
        console.debug(pbutton);
        if (pbutton && typeof(pbutton) !== 'undefined')
            this.loadPrintButtonOptions(pbutton, this.record.id);
    },
    onRecalc: function(){
        console.debug('recalculate');
        //this.recalc({orderId: this.recordId});
        this.onApply();
    }
}