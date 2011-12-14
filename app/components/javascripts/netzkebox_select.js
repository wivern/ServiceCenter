/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 27.10.11
 * Time: 16:14
 * To change this template use File | Settings | File Templates.
 */
Ext.define('Ext.netzke.BoxSelect', {
    extend: 'Ext.ux.form.field.BoxSelect',
    alias: 'widget.netzkeboxselect',
    createNewOnEnter: true,
    createNewOnBlur: true,
    forceSelection: false,
    hideTrigger: false,
    minChars: 1,
    delimiter: ',',
    mixins: {
        storable: 'Ext.netzke.Storable'
    },
    initComponent: function() {
        this.initStore();
        this.callParent(arguments);
        console.debug(this.autoLoadStore, this.store);
            if (this.autoLoadStore && this.store.count() == 0)
                this.store.load();
    },
});

Ext.define('Ext.netzke.PopupSelect', {
    extend: 'Ext.netzke.BoxSelect',
    alias: 'widget.netzkepopupselect',
    hideTrigger: false,
    valueField: 'id',
    displayField: 'name',
    selectionComponent: 'popup',
    mixins: {
        storable: 'Ext.netzke.Storable'
    },
    initStore: function(){
        if (this.autoLoadStore)
            this.callParent();
        else
            this.initInMemoryStore();
    },
    initInMemoryStore: function(){
        var modelName = this.parentId + "_" + this.name;

        console.log( this.name + ' fields',this.valueField, this.displayField);
        Ext.define(modelName, {
            extend: 'Ext.data.Model',
            fields: [this.valueField, this.displayField]
        });

        var store = new Ext.data.Store({
            model: modelName,
            proxy: {
                type: 'memory',
                reader: {
                    type: 'array',
                    root: 'data'
                }
            }
        });
        this.store = store;
    },
    onTriggerClick: function() {
        if (this.selectWindow) {
            this.selectWindow.show();
        } else {
            var parent = this.findParentBy(function(p) {
                console.debug('found: ', p);
                return typeof(p.getForm) == 'function';
            });
            var self = this;
            if (parent) {
                parent.loadNetzkeComponent({name: this.selectionComponent, callback: function(win) {
                    self.selectWindow = win;
                    self.selectWindow.show();
                    win.on('hide', function() {
                        var selected = win.selection;
                        if (win.closeResult == 'select') {
                            console.debug(selected);
//                        this.store.removeAll(true);
                            this.store.add(selected);
                            this.addValue(selected.get(this.valueField));
                            console.log('added', this.getSubmitData());
                        }
                    }, self);
                }});
            }
        }
    }
});