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
    updateTitle: function(){
        var number = this.record.number;
        this.setTitle('Карточка заказа № ' + number);
    },
    handlePrintClick: function(item, e){
       console.debug(item);
       var printForm = Ext.get("print-form");
       printForm.dom.action = "/print/" + item.reportId + "/" + this.record.id;
       printForm.dom.submit();
    },
    updateToolbar: function(){
        var tbar = this.child('toolbar');
        var pbutton = tbar.child('button[name=print]');
        pbutton.menu.removeAll();
        this.getPrintOptions({ orderId: this.record.id },function(items){
            for(index in items){
              var item = pbutton.menu.add(items[index]);
              item.on('click', this.handlePrintClick, this);
//                items[index].recordId = this.record.id;
            }
        },this);
    }
}