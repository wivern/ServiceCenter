/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 22.11.11
 * Time: 15:50
 * To change this template use File | Settings | File Templates.
 */

Ext.define('Ext.ux.SelectTriggerField',
{
    extend: "Ext.form.field.ComboBox",
    alias: "widget.selecttriggerfield",
    valueField: 'id',
    displayField: 'name',
    editable: false,
    selectionComponent: 'select_window',
    triggerCls: 'x-form-browse-trigger',

    initComponent: function(){
        this.store = new Ext.data.ArrayStore({
            id: 0,
            fields: [this.valueField, this.displayField],
            data: []
        });
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
            var self = this;
            parent.loadNetzkeComponent({name: this.selectionComponent, callback: function(win){
                self.selectWindow = win;
                self.selectWindow.show();
                win.on('hide', function(){
                    var selected = win.selection;
                    if (win.closeResult == 'select'){
                        console.debug(selected);
//                        this.store.removeAll(true);
                        this.store.add(selected.data);
                        this.setValue(selected.get(this.valueField));
                        console.debug(this.store);
                    }
                }, self);
            }});
        }
    }
});