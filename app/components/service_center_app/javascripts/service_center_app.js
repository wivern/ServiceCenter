/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 10.11.11
 * Time: 14:13
 * To change this template use File | Settings | File Templates.
 */
{
    initComponent: function(){
       this.callParent();
       this.mainPanel.on("added", function(cmp, container, pos, eopts){
          console.debug("added " + Ext.getClassName(cmp));
       });
    },
    select_by_token: function(token){
      if (token) {
        var node = this.navigation.getStore().getRootNode().findChildBy(function(n){
          return n.raw.component == token;
        }, this, true);

        if (node) this.navigation.getView().select(node);
      }
    },

    processHistory: function(token){
        this.select_by_token(token);
        this.callParent([token]);
//      var component = this.mainPanel.down('panel');
//      if (component && typeof(component) != 'undefined'){
//        if (typeof component.submit == 'function' && component.getForm().isDirty()){
//                var form = component.getForm();
//                var self = this;
////                Ext.MessageBox.show({
////                    buttons: Ext.MessageBox.YESNOCANCEL,
////                    icon: Ext.MessageBox.QUESTION,
////                    title: 'Сохранить изменения?',
////                    msg: 'Вы хотите закрыть страницу с несохраненными данными. Сохранить изменения?',
////                    fn: function(btn){
////                        if (btn == 'yes'){
////                            form.submit();
////                            form.reset();
////                        }
////                        if (btn != 'cancel') {
////                            self.select_by_token(token);
////                            self.callParent([token]);
////                        } else self.select_by_token(Ext.util.History.getToken());
////                    }
////                });
//        } else {
//          console.debug("not a form");
//          this.select_by_token(token);
//          this.callParent([token]);
//        }
//      }else{
//        console.debug("no component");
//        this.select_by_token(token);
//        this.callParent([token]);
//      }
    }


}