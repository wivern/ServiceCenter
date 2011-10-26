/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 18.10.11
 * Time: 17:12
 * To change this template use File | Settings | File Templates.
 */

Ext.namespace('Ext.ux');

Ext.QuickTips.init();

Ext.define('Ext.ux.autosuggestField', {
    extend: 'Ext.form.field.ComboBox',
    alias: 'widget.autosuggest',
    valueField: 'record_id',
    displayField: 'value',
    submitValue: true,
    typeAhead: true,
    triggerAction: 'all',
    emptyText: 'type something',
    selectOnFocus: true,
    hideTrigger: true,
    populateRelatedFields: false, //when true so fill other related fields with values
    minChars: 3,

    initComponent: function() {
        var modelName = this.parentId + "_" + this.name;

        Ext.define(modelName, {
            extend: 'Ext.data.Model',
            fields: ['record_id', 'value']
        });


        var store = new Ext.data.Store({
            model: modelName,
            proxy: {
                type: 'direct',
                directFn: Netzke.providers[this.parentId].getAutoSuggest,
                reader: {
                    type: 'array',
                    root: 'data'
                }
            }
        });

        store.on('beforeload', function(self, params) {
            params.params.column = this.name;
        }, this);

        if (this.store) store.loadData({data: this.store});

        this.store = store;

        Ext.apply(this, { hiddenName : this.parentId + "_id" });

        this.callParent();
    },
    collapse: function() {
        // HACK: do not hide dropdown menu while loading items
        if (!this.store.loading) this.callParent();
    },
    /* Send both value id and display for field */
//    getSubmitData: function(){
//        var me = this, data = null;
//        if (!me.disabled && me.submitValue && !me.isFileUpload()) {
//            data = {};
//            data[me.getName()] = '' + me.getValue();
//            var path = me.getName().split('__');
//            path[path.length - 1] = me.valueField;
//            data[path.join('__')] = '' + me.getRawValue();
//        }
//        return data;
//    },
    listeners: {
        'select': function(combo, records, options) {
            if (this.populateRelatedFields) {
                var domain = this.name.split("__")[0];
                if (!this.maskCmp) this.maskCmp = new Ext.LoadMask(this.getEl(), {msg: "Updating..."});
                this.maskCmp.show();
                Netzke.providers[this.parentId].loadAssociatedData({ form_id: this.parentId, column: this.name, selected: combo.getValue() }, function(result) {
                    this.maskCmp.hide();
                    //populate form fields
                    console.debug("Result:", typeof result.setResult, result.setResult);
                    var record_store = eval('(' + result.setResult + ')');
                    var fields = Ext.ComponentQuery.query("[isFormField]"); //input[name^=" + domain + "]
//                console.debug("Found: " + fields.length + ", domain: " + domain, "for: " + this.name);
                    Ext.each(fields, function(field) {
                        if (field.name.substring(0, domain.length) == domain && this.name != field.name) {
                            var columns = field.name.split("__");
                            //add record to suggest store
                            if (field.xtype == "autosuggest"){
                                var path = columns.slice(0, columns.length - 1);
                                var record_id = eval("record_store." + path.join('.') + ".id");
                                var data = { record_id : record_id,
                                    value: eval("record_store." + columns.join('.')) }
                                field.store.add(data);
                                field.setValue(record_id);
                            } else
                                field.setValue(eval("record_store." + columns.join('.')));
                        }
                    }, this);
                }, this);
            }
        }
    }

});