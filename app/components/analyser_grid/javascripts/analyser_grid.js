{
    defaults: {
      readOnly: true
    },
    initComponent: function(){
        this.callParent();
        Ext.override(Ext.ux.grid.FiltersFeature,{
           menuFilterText: 'Фильтры'
        });
        Ext.each(this.columns, function(c){
            if (!c.meta)
                c.editable = false;
            console.debug('column: ' + c.name, c.filter);
            if (c.filter && c.filter.type === 'list'){
                console.debug('list column', c);
                var compname;
                if (c.filter.valueModel && typeof(c.filter.valueModel) !== 'undefined')
                    compname = c.filter.valueModel;
                else
                    compname = c.name.split("__")[0];
                Ext.define(compname,{
                   extend: 'Ext.data.Model',
                    fields: [
                        {name: 'id', type: 'int'},
                        {name: 'name', type: 'string'}
                    ]
                });
                var proxy = {
                    type: 'direct',
                    directFn: Netzke.providers[this.id].getListFilterData,
                    reader:{
                        type: 'json',
                        root: 'result'
                    }
                };
                var me = this;
                c.filter.phpMode = true;
                c.filter.labelField = 'name';
                c.filter.options = [];
                c.filter.listeners = {
                    update: function(filter){
                    console.debug('update to', filter);
                    }
                };
//                c.filter.dataIndex = compname + 'Store';
                var store = Ext.create('store.store',{
                    model: compname,
                    storeId: compname + 'Store',
                    proxy: proxy,
                    autoLoad: false,
                    listeners: {
                        load: function(s){
                            console.debug('load data for ' + s.name);
                        }
                    }
                 });
                store.proxy.extraParams = {
                  'model': compname,
                  'scope': c.filter.scope
                };
                c.filter.store = store;
            }
        }, this);
    }
}