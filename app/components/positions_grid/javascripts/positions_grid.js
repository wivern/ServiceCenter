{
    onEditInForm: function(){
        var selModel = this.getSelectionModel();
        if (selModel.getCount() > 1) {
            //TODO add multiedit form
        } else {
            var recordId = selModel.selected.first().getId();
            if (this.editForm === undefined){
                this.loadNetzkeComponent({name: "edit_position_form",
                  params: {record_id: recordId},
                  callback: function(w){
                    this.editForm = w;
                    w.show();
                    w.on('close', function(){
                      if (w.closeRes === "ok") {
                        this.store.load();
                      }
                    }, this);
                  }, scope: this});
            } else {
                var form = this.editForm;
                form.closeRes = 'cancel';
                form.items.get(0).netzkeLoad({id: recordId});
                form.show();
            }
        }
    }
}