/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 11.11.11
 * Time: 16:34
 * To change this template use File | Settings | File Templates.
 */
{
    afterRender: function(){
        this.callParent();

        if (this.record){
            this.updateToolbar();
            this.updateTitle();
        }
    },
    trackResetOnLoad: true,
    initialConfig:{
        trackResetOnLoad: true
    },
    initComponent: function(){
      this.callParent();
      var fields = this.extractFields();
      console.debug('form', this.getForm());
      var fields = this.getForm().getFields();
      var diagField = this.getForm().findField("diagnostic_activity__name");
      var activitiesGrid = this.down("#activities");
      console.debug("Activities", activitiesGrid);
      if (typeof(diagField) !== 'undefined' && diagField){
         console.debug('diag_field', diagField);
         var me = this;
         this.firstSetValue = true;
         diagField.on('change', function(field, newValue, oldValue){
             console.debug("DiagPrice changed to " + newValue);
             if (me.firstSetValue){
                 me.firstSetValue = false;
                 return;
             }
             //add selected activity to order activities
             try{
                 /*if (typeof(oldValue) !== 'undefined')
                    me.removeActivity({order_id: me.record.id, activity_id: oldValue}); */
                 //Remove all diagnostic activities first
                 me.removeAllDiagActivities({order_id: me.record.id});
                 me.addActivity({order_id: me.record.id, activity_id: newValue});
             }catch(e){}
             activitiesGrid.onRefresh();
         });
      }
/*      Ext.each(this.getForm().getFields(), function(item){
         console.debug('Item:', item);
      }); */
    },
    updateTitle: function(){
        var number = this.record.ticket;
        this.setTitle('Карточка заказа № ' + number);
    },
    updateToolbar: function(){
        var tbar = this.child('toolbar');
        var pbutton = tbar.child('button[name=print]');
        console.debug(pbutton);
        if (pbutton && typeof(pbutton) !== 'undefined')
            this.loadPrintButtonOptions(pbutton, this.record.id);
    },
    onRecalc: function(){
        console.debug('recalculate');
        //this.recalc({orderId: this.recordId});
        this.onApply();
    }
}