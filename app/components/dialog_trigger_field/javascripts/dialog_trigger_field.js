/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 22.11.11
 * Time: 15:50
 * To change this template use File | Settings | File Templates.
 */

Ext.define('Ext.ux.SelectTriggerField',
{
    extend: "Ext.form.field.Trigger",
    alias: "widget.selecttriggerfield",
    valueField: 'record_id',
    displayField: 'value',
    editable: false,
    selectionComponent: 'select_window',

    initComponent: function(){
        this.callParent();
    },
    onTriggerClick: function(){
        console.log('trigger');
        if (this.selectWindow){
            this.selectWindow.show();
        } else {
            var parent = this.findParentBy(function(p){
               console.debug('found: ', p);
                return typeof(p.getForm) == 'function';
            });
            parent.loadNetzkeComponent({name: this.selectionComponent, callback: function(win){
                this.selectWindow = win;
                this.selectWindow.show();
            }});
        }
    }
});