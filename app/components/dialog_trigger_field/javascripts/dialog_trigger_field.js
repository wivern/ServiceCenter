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
        var names = this.name.split('__');
        this.selectionComponent = "select_" + names[0];
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
            var parent = Ext.getCmp(this.parentId), self = this;
            if (!parent)
                parent = this.findParentBy(function(p){
                   console.debug('found: ', p);
                    return typeof(p.getForm) == 'function';
                });
            console.debug('Parent',parent);
            if (parent)
                parent.loadNetzkeComponent({name: this.selectionComponent, callback: function(win){
                    self.selectWindow = win;
                    self.selectWindow.show();
                    win.on('hide', function(){
                        console.log('closing');
                        var selected = win.selection;
                        if (win.closeResult == 'select'){
                            console.debug(selected);
    //                        this.store.removeAll(true);
                            self.store.add(selected.data);
                            self.setValue(selected.get(this.valueField));
                            parent.refresh && parent.refresh();
                            console.debug('self.store', self);
                        }
                    }, self);
                }});
        }
    }
});