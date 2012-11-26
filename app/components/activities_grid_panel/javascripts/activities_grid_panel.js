/**
 * Created with JetBrains RubyMine.
 * User: vitaly
 * Date: 21.11.12
 * Time: 11:51
 * To change this template use File | Settings | File Templates.
 */
{
    viewConfig:{
        plugins:{
            dragGroup: 'ddActivities',
            ptype: 'gridviewdragdrop',
            pluginId: 'griddragdrop',
            enableDrop: false
        },
        listeners: {
            drop: function(node, data, dropRec, dropPosition){
                console.debug("drop");
                return false;
            }
        }
    },
    initComponent: function(){
        this.enableDragDrop = this.editable;
        this.callParent();
        this.on('afterrender', function(){
            var plugin = this.view.getPlugin('griddragdrop');
            if (!this.editable){
                console.debug('DnD disabled');
                plugin.disable();
                plugin.dragZone.lock();
            }
        });
    }
}