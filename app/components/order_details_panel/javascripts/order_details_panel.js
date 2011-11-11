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
    updateToolbar: function(){
        var tbar = this.child('toolbar');
        var pbutton = tbar.child('button[name=print]');
        pbutton.menu.removeAll();
        this.getPrintOptions({},function(items){
            pbutton.menu.add(items);
        },this);
//        pbutton.menu.add([
//                {text: 'Квитанция'},
//                {text: 'Карточка ремонта'}
//            ]);
    }
}