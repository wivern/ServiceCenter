/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 27.10.11
 * Time: 16:18
 * To change this template use File | Settings | File Templates.
 */
Ext.define('Ext.netzke.Storable',{
   valueField: 'record_id',
   displayField: 'value',
   queryMode: 'remote',
   initStore: function(){
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
   }
});