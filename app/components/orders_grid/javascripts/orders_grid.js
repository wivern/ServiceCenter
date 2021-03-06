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
 /*                   autoLoad:{
                        params:{
                            model: compname
                        },
                        callback: function(){
                            console.debug('callback', c);
                            if (typeof(c.filterOnLoad) !== 'undefined')
                                c.filterOnLoad(this, this.data);
                        }
                    } */
                 });
                store.proxy.extraParams = {
                  'model': compname,
                  'scope': c.filter.scope
                };
                c.filter.store = store;
            }
        }, this);


        var bbar = this.getDockedItems('pagingtoolbar')[0];
        var createFrom = bbar.child('button[name=createFrom]');
        var me = this;
        createFrom.menu.items.each(function(i){
           console.debug(i);
            i.on('click', me.onCreateOrderFrom, me);
        });
//        Ext.each(createFrom.menu.items, function(c){
//            console.debug(c);
//            if (c)
//                c.on('click', this.onCreateOrderFrom);
//        });
        this.getSelectionModel().on('selectionchange', function(selModel, selected){
           var disabled = selected.length === 0;
           if (!disabled && selected[0].isNew) disabled = true;
           this.actions.open.setDisabled(disabled);
           var bbar = this.getDockedItems('pagingtoolbar')[0];
           bbar.child('button[name=createFrom]').setDisabled(disabled);
           var print = bbar.child('button[name=print]');
           if (print && typeof(print) !== 'undefined')
            print.setDisabled(disabled);
        }, this);
        //create_from menu
    },
    openOrderDetails: function(orderId){
        this.getView().openOrderDetails(orderId);
    },
    selModel:{
      mode: 'SINGLE'
    },
    listeners:{
      selectionchange: function(view, selections, options){
          var bbar = this.getDockedItems('pagingtoolbar')[0];
          console.debug(bbar);
          if (bbar){
            var pbutton = bbar.child('button[name=print]');
            if (selections[0] && pbutton && typeof(pbutton) !== 'undefined'){
                this.loadPrintButtonOptions(pbutton, selections[0].get('id'));
            }
          }
      }
    },
    onCreateOrderFrom:function(item, e){
        console.debug('create from', item);
        var me = this;
        var selection = this.getView().getSelectionModel().getSelection();
        if (selection.length > 0){
            var order = selection[0];
            Ext.MessageBox.show({
                title: me.i18n.confirmation,
                msg: 'Вы согласны создать заказ на основании выбранного?',
                buttons: Ext.MessageBox.YESNO,
                icon: Ext.MessageBox.QUESTION,
                fn: function(btn){
                    if (btn === 'yes'){
                       console.debug('create from', order);
                       me.createFrom({
                           order_id: order.get('id'),
                           repair_type_id: item.repairType
                       });
                    }
                }
            });
        }
    },
    onFilterBySerialNum: function(item, e){
        console.debug('filter by s/n');
        var me = this;
        var selection = this.getView().getSelectionModel().getSelection();
        item.toggle();
        if (item.pressed){
            if (selection.length > 0){
                console.debug('apply filter');
                var order = selection[0];
                var snumber =  order.data._meta.associationValues.product_passport__factory_number; //order.get('product_passport__factory_number');
                console.debug('snumber', snumber, order);
                this.filters.createFilters();
                //Activate s/n filter
                var snFilter = this.filters.getFilter('product_passport__factory_number');
                if (!snFilter){
                    snFilter = this.filters.addFilter({
                       type: 'string',
                       dataIndex: 'product_passport__factory_number'
                    });
                }
//                snFilter.setActive(true);
                Ext.Function.defer(function(){
                   snFilter = this.filters.getFilter('product_passport__factory_number');
                   snFilter.setValue(snumber);
                }, 10, this);
                //Turn off other filters
//                this.filters.clearFilters();
                console.debug("Turn off filters");
                var filters = this.filters.filters;
                console.debug("Filters", filters);
                filters.each(function(item, index){
                    console.debug("Item", item, index);
                    item.setActive(item == snFilter);
                }, this);
                var ticketFilter = this.filters.getFilter('ticket');
                if (ticketFilter) ticketFilter.setValue([]);
                console.debug('ticketFilter', ticketFilter);
            }
        } else {
           console.debug("clear filter");
            var snFilter = this.filters.getFilter('product_passport__factory_number');
            snFilter.setActive(false);
        }

    },
    openOrder: function(orderId, number){
      this.getView().openOrder(orderId, number);
    },
    onOpen: function(){
       if (this.getView().getSelectionModel().getSelection().length > 0){
           this.getView().openOrderDetails(this.getView().getSelectionModel().getSelection()[0]);
       }
    },
    viewConfig:{
        openOrder: function(orderId, number){
            console.debug('orderId is', typeof(orderId));
            if (typeof(orderId) === 'object'){
                number = orderId[1];
                orderId = orderId[0];
            }
          var app = Ext.ComponentQuery.query('viewport')[0];
//            app.selectOrder({order_id: orderId});
            app.addTab('OrderDetailsPanel',{
                config:{
                    record_id: orderId,
                    title: 'Заказ № ' + number
                }
            });
        },
        openOrderDetails: function(record){
            var orderId = record.get('id'),
                number = record.get('ticket');
            this.openOrder(orderId, number);
//            app.appLoadComponent('order_details');
        }
    }
}