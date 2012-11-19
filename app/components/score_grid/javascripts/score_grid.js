{
    initComponent: function(){
        this.callParent();
        var tbar;
         Ext.each(this.getDockedItems(''), function(item){
            if (item.dock == 'top'){
                tbar = item;
                return false;
            }
         });
        if (tbar){
             console.debug('tbar found', tbar);
             var monthBtn = tbar.child("button[name=month]"), today = new Date;
             this.printingDate = today;
             if (monthBtn){
                 console.debug('monthBtn found', monthBtn, monthBtn.menu);
                 monthBtn.setText( Ext.Date.monthNames[today.getMonth()] + ' ' + today.getFullYear());
                 var picker = monthBtn.menu.items.items[0], me = this;
                 if (picker){
                     console.debug('picker', picker);
                     picker.on('select', function(datePicker, date){
                         console.log('date selected', date);
                         monthBtn.hideMenu();
                         monthBtn.setText(Ext.Date.monthNames[date.getMonth()] + ' ' + date.getFullYear());
                         me.printingDate = date;
                         me.changeMonth({'date' : date});
                         me.onRefresh();
                     }, this);
                 }
             }
         } else console.debug('tbar not found');
    },
    onPrintPayments: function(){
        var dateStr = this.printingDate.getFullYear() + '-' + (this.printingDate.getMonth()+1) + '-' +
               this.printingDate.getDate();
        console.debug('printingDate', this.printingDate, dateStr);
        printForm.dom.action = '/print/payments.odt/' + dateStr;
        console.debug('action', printForm.dom.action);
        printForm.dom.submit();
    }
}