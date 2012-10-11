/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 14.02.12
 * Time: 16:48
 */

{
    initComponent: function(){
        this.callParent();
        var win = this.getChildNetzkeComponent(this.id + '__select_activity');
        console.debug('Searching', this.id + '__select_activity');
        for(i in this.columns){
            var column = this.columns[i];
            if ("activity__code" === column.dataIndex)
                column.summaryRenderer = this.totalRenderer;
            else if ("activity__price" === column.dataIndex){
                column.summaryRenderer = this.summaryRenderer;
                column.summaryType = this.sumAmount;
            }
        }
        if (win){
            console.debug('found', win);
            win.on('activityadded', function(){
                this.store.load();
            }, this);
        }
    },
    sumAmount: function(values){
      var amount = 0;
      for(i in values) amount += parseFloat(values[i].data._meta.associationValues.activity__price);
      return amount;
    },
    totalRenderer: function(value,data,dataIndex){
        return "<b>Итого:</b>";
      },
    summaryRenderer: function(value, data, dataIndex){
        return Ext.util.Format.currency(value, ' руб.', 2, true);
    },
    onAddInline: function(){
       if (!this.selectActivityWindow){
          this.loadNetzkeComponent({
                  name: 'select_activity',
                  callback: function(comp){
                      this.selectActivityWindow = comp;
                      comp.show();
                      comp.on('activityadded', function(){
                         this.store.load();
                      }, this);
                  }
              }
          );

       } else {
           this.selectActivityWindow.orderId = this.orderId;
           this.selectActivityWindow.show();
       }
    }
}