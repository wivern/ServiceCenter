/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 15.11.11
 * Time: 13:47
 */

{
    processHistory: function(token){
        console.debug('process history');
        if (token){

            var token_id = token + '_tab';
            var tab = this.mainPanel.items.findBy(function(i){
                return i.id == token_id;
            });

            console.debug(tab);
            if (tab){
                this.mainPanel.setActiveTab(tab);
            } else {
                tab = this.mainPanel.add({
    //                title: token,
                    id: token_id,
                    iconCls: 'icon-tab',
                    closable: true,
                    layout: 'fit'
                });
                this.loadNetzkeComponent({name: token, callback: function(comp){
                    tab.setTitle(comp.title);
                    comp.preventHeader = true;
                    tab.add(comp);
                    tab.show();
                    this.mainPanel.doLayout();
                }});
            }
        } else {
            this.mainPanel.removeAll();
        }
    }
}