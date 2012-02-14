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
        if (win){
            console.debug('found', win);
            win.on('activityadded', function(){
                this.store.load();
            }, this);
        }
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

       } else this.selectActivityWindow.show();
    }
}