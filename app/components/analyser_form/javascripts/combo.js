/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 03.02.12
 * Time: 14:28
 * To change this template use File | Settings | File Templates.
 */
Ext.define('Ext.sc.ComboBox',{
  extend        : 'Ext.form.field.ComboBox',
  alias         : 'widget.scremotecombo',
  valueField    : 'field1',
  displayField  : 'field2',
  triggerAction : 'all',

  initComponent : function(){
    var modelName = this.parentId + "_" + this.name;

    Ext.define(modelName, {
        extend: 'Ext.data.Model',
        fields: ['field1', 'field2']
    });

    var store = new Ext.data.Store({
      model: modelName,
      proxy: {
        type: 'direct',
        directFn: Netzke.providers[this.parentId].getComboboxOptions,
        reader: {
          type: 'array',
          root: 'data'
        }
      }
    });

    var params = store.getProxy().extraParams;
    params.model = this.model;
    if (this.scope)
        params.scope = this.scope;

    // If inline data was passed (TODO: is this actually working?)
    if (this.store) store.loadData({data: this.store});

    this.store = store;

    this.callParent();
  },

  collapse: function(){
    // HACK: do not hide dropdown menu while loading items
    if( !this.store.loading ) this.callParent();
  }
});