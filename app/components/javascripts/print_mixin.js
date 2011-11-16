/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 16.11.11
 * Time: 13:22
 * To change this template use File | Settings | File Templates.
 */
{
    handlePrintClick: function(item, e){
       console.debug(item);
       var printForm = Ext.get("print-form");
       printForm.dom.action = "/print/" + item.reportId + "/" + item.orderId;
       printForm.dom.submit();
    },
    loadPrintButtonOptions: function(pbutton, recordId){
        pbutton.menu.removeAll();
        this.getPrintOptions({ orderId: recordId },function(items){
            for(index in items){
              var item = pbutton.menu.add(items[index]);
              item.on('click', this.handlePrintClick, this);
            }
        },this);
    }
}