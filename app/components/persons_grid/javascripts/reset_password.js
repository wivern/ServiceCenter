/**
 * User: vitaly
 * Date: 26.12.11
 * Time: 17:17
 */
{
    onResetPassword: function(){
        var selModel = this.getSelectionModel();
        var recordId = selModel.selected.first().getId();
        this.loadNetzkeComponent({
           name: 'reset_password_form',
           params: {record_id: recordId},
           callback: function(w){
               w.show();
               w.on('close', function(){
                  if (w.closeRes === "ok"){
                      //some message
                      Ext.MessageBox.show({
                          title: "Смена пароля",
                          msg: "Пароль успешно изменен!",
                          buttons: Ext.MessageBox.OK,
                          icon: Ext.MessageBox.INFO
                      });
                  }
               }, this);
           },
           scope: this });
    }
}