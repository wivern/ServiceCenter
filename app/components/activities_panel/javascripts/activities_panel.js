/**
 * Created with JetBrains RubyMine.
 * User: vitaly
 * Date: 20.11.12
 * Time: 15:25
 * To change this template use File | Settings | File Templates.
 */
{
    initComponent: function(){
        this.callParent();
        this.tree = this.getChildNetzkeComponent('activities_tree');
        this.grid = this.getChildNetzkeComponent('activities_grid');
        this.tree.on('selectionchange', this.onTreeSelectionChange, this);
//        this.grid.enableDragDrop = true;
        this.tree.on('ontreenodedrop', function(node, data, tree){
            console.debug('move activities', node, data);
            var children = [];
            Ext.each(data.records, function(item, index, allItems){
               children.push(item.get('id'));
            }, this);
            this.moveToFolder({parent: node.get('id'), children: children});
            this.grid.onRefresh();
        }, this);
    },
    onTreeSelectionChange: function(tree, selection){
        console.debug('selection changed', selection);
        this.setFilter({parent: selection[0].get('id')},function(){
            this.grid.getStore().loadPage(1);
            //this.grid.onRefresh();
        }, this);
    }
}