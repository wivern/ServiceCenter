/**
 * User: vitaly
 * Date: 21.12.11
 * Time: 10:42
 */
{
    initComponent: function(){
        this.callParent();
        var win = this.getChildNetzkeComponent(this.id + '__select_spare_part');
        console.debug('Searching', this.id + '__select_spare_part');
        if (win){
            console.debug('found', win);
            win.on('partsadded', function(){
                this.store.load();
            }, this);
        }
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