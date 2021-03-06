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
   autoLoadStore: false,

   initStore: function(){
       var modelName = this.parentId + "_" + this.name;

       console.log( this.name + ' fields',this.valueField, this.displayField);
       Ext.define(modelName, {
           extend: 'Ext.data.Model',
           fields: [this.valueField, this.displayField]
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

       store.getProxy().extraParams.column = this.name;

//       store.on('beforeload', function(self, operation) {
//           console.debug(operation);
//           operation.extraParams.column = this.name;
//       }, this);

       if (this.store) store.loadData({data: this.store});

       this.store = store;

   }
});