/**
 * User: vitaly
 * Date: 11.01.12
 * Time: 14:19
 */

{
    initComponent: function(){
        this.callParent();
        if (this.actions.merge) this.actions.merge.setDisabled(true);
        this.getSelectionModel().on('selectionchange', function(selModel){
            if (this.actions.merge) this.actions.merge.setDisabled(selModel.getCount() < 2);
        }, this);
    },

    onMerge: function(){
        Ext.Msg.confirm(this.i18n.confirmation, this.i18n.sureToMergeItems, function(btn){
            if (btn === 'yes'){
                var items = [];
                this.getSelectionModel().selected.each(function(r){
                   items.push(r.getId()); //TODO what to do if record is new?
                });
                if (items.length > 0){
                    this.mergeItems({items: Ext.encode(items)}, function(){
                        this.onRefresh();
                    }, this);
                }
            }
        }, this);
    }
}
