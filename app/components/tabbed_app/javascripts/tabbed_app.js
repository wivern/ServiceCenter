/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 15.11.11
 * Time: 13:47
 */

{
    addTab: function(cmp, options){
        var tabCount = this.mainPanel.items.getCount(), cmpName, params, tab;
        cmpName = "tab" + (tabCount + 1);
        params = {component: cmp};
        params.config = options.config;
        this.loadNetzkeComponent({name: cmpName, params: params, callback: function(comp){
            var tab = this.mainPanel.add({
//                title: token,
                id: cmpName,
                iconCls: 'icon-tab',
                closable: true,
                layout: 'fit'
            });
            tab.setTitle(comp.title);
            comp.preventHeader = true;
            tab.add(comp);
            tab.netzkeComponentId = comp.itemId;
            this.mainPanel.setActiveTab(tab);
        }});
    },
    initComponent: function(){
        this.callParent();
        this.mainPanel.on('remove',function(me, tab){
            if (typeof(tab.netzkeComponentId) !== 'undefined' &&
                tab.netzkeComponentId.match(/^tab\d+$/)){
                console.debug("Removing", tab);
                this.serverRemoveTab({name: tab.netzkeComponentId});
            }
        }, this);
        this.mainPanel.on('tabchange',function(panel, tab){
            Ext.History.add(tab.id);
        }, this);
    },
    processHistory: function(token){
        console.debug('process history');
        if (token){

            var token_id = token;
            var tab = this.mainPanel.items.findBy(function(i){
                return i.id == token_id;
            });

            if (tab){
                this.mainPanel.setActiveTab(tab);
            } else {
                this.loadNetzkeComponent({name: token, callback: function(comp){
                   var tab = this.mainPanel.add({
        //                title: token,
                        id: token_id,
                        iconCls: 'icon-tab',
                        closable: true,
                        layout: 'fit'
                    });
                    tab.setTitle(comp.title);
                    comp.preventHeader = true;
                    tab.add(comp);
                    tab.show();
                    this.mainPanel.doLayout();
                    this.mainPanel.setActiveTab(tab);
                }});
            }
        } else {
//            this.mainPanel.removeAll();
        }
    }
}