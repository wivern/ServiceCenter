/**
 * User: vitaly
 * Date: 21.12.11
 * Time: 10:42
 */
{
    initComponent: function(){
        this.callParent();
        for(col in this.columns){
            console.debug("column", this.columns[col]);
            var column = this.columns[col];
            if ("spare_part__name" === column.dataIndex)
                column.summaryRenderer = this.totalRenderer;
            else if ("amount" === column.dataIndex){
                column.summaryRenderer = this.summaryRenderer;
                column.summaryType = this.sumAmount;
            }
        }
        var win = this.getChildNetzkeComponent(this.id + '__select_spare_part');
        console.debug('Searching', this.id + '__select_spare_part');
        if (win){
            console.debug('found', win);
            win.on('partsadded', function(){
                this.store.load();
            }, this);
        }
    },
    sumAmount: function(values){
      console.debug('sum', values);
      var amount = 0;
      for(i in values) amount += parseFloat(values[i].data.amount);
      return amount;
    },
    totalRenderer: function(value,data,dataIndex){
        return "<b>Итого:</b>";
      },
    summaryRenderer: function(value, data, dataIndex){
        return Ext.util.Format.currency(value, ' руб.', 2, true);
    },
    onAddInline: function(){
       if (!this.selectPartWindow){
          this.loadNetzkeComponent({
                  name: 'select_spare_part',
                  callback: function(comp){
                      this.selectPartWindow = comp;
                      comp.show();
                      comp.on('partsadded', function(){
                         this.store.load();
                      }, this);
                  }
              }
          );

       } else this.selectPartWindow.show();
    }
}