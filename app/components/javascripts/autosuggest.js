/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 18.10.11
 * Time: 17:12
 * To change this template use File | Settings | File Templates.
 */

Ext.namespace('Ext.ux');

Ext.define('Ext.ux.AutosuggestField', {
    extend: 'Ext.form.field.ComboBox',
    mixins:{
        storable: 'Ext.netzke.Storable'
    },
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
    allowNew: false, //Allow hand-type new items, not only found in list

    initComponent: function() {
        this.initStore();
        this.callParent();
    },
    collapse: function() {
        // HACK: do not hide dropdown menu while loading items
        if (!this.store.loading) this.callParent();
    },
    validator: function(v){
       if (this.allowNew || /^\d+$/.test(this.getValue()))
        return true;
       else return "Выберите значение из списка";
    },
    listeners: {
        'select': function(combo, records, options) {
            if (this.populateRelatedFields) {
                var domain = this.name.split("__")[0];
                if (!this.maskCmp) this.maskCmp = new Ext.LoadMask(this.getEl(), {msg: "Updating..."});
                this.maskCmp.show();
                Netzke.providers[this.parentId].loadAssociatedData({ form_id: this.parentId, column: this.name, selected: combo.getValue() }, function(result) {
                    this.maskCmp.hide();
                    //populate form fields
//                    console.debug("Result:", typeof result.setResult, result.setResult);
                    var record_store = eval('(' + result.setResult + ')');
                    var fields = Ext.ComponentQuery.query("[isFormField]"); //input[name^=" + domain + "]
                    console.debug("RecordStore", record_store);
//                console.debug("Found: " + fields.length + ", domain: " + domain, "for: " + this.name);
                    Ext.each(fields, function(field) {
                        if (field.name.substring(0, domain.length) == domain && this.name != field.name) {
                            var columns = field.name.split("__");
                            console.debug(field.name);
                            var value = eval("record_store." + columns.join('.'));
                            //add record to suggest store
                            if (field.xtype == "autosuggest" || field.xtype == "selecttriggerfield"){
                                var path = columns.slice(0, columns.length - 1);
                                var record_id = eval("record_store." + path.join('.') + ".id");
                                //var data = { record_id : record_id, value: value };
                                if (record_id && value){
                                    var data = new Object();
                                    eval('data.' + field.valueField + '=' + record_id + ';');
                                    eval('data.' + field.displayField + '= "' + value + '";');
                                    console.debug(data);
                                    field.store.removeAll();
                                    field.store.add(data);
                                    field.setValue(record_id);
                                } else field.reset();
                            } else
                                field.setValue(value);
                        }
                    }, this);
                }, this);
            }
        }
    }

});