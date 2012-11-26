/**
 * User: vitaly
 * Date: 09.11.12
 * Time: 15:40
 */

{
    loadMask: true,
    componentLoadMask: {msg: "Загрузка..."},
    enableDragDrop: true,
    initComponent: function(){
        var me = this;
        var proxy = {
            type: 'direct',
            directFn: Netzke.providers[this.id].getData,
            reader: {
                type: 'json',
                root: 'data'
            },
            listeners:{
                exception: {
                  fn: this.loadExceptionHandler,
                  scope: this
                },
                load: {
                    fn: function(proxy, response, operation){
                        response = response.result;
                        console.debug('tree response', response);
                        if (response){
                            this.bulkExecute(response);
                        }
                    } ,
                    scope: this
                }
            }
        };
        var store = new Ext.data.TreeStore({
            root:{
                id: 'source',
                nodeType:'async',
                text: 'Root'
            },
            model: this.id,
            proxy: proxy,
            autoLoad: true
        });
        this.store = store;
        me.addEvents('ontreenodedrop');
        this.callParent();
        // Context menu
        if (this.contextMenu) {
          this.on('itemcontextmenu', this.onItemContextMenu, this);
        }
        if (this.editable){
            this.getView().on('afterrender', function(){
               var plugin = this.view.getPlugin('dragdrop');
               var me = this;
               console.debug('me',me);
               var dz = plugin.dropZone;
               dz.isNodeIdValid = function(nodeId){
                   return 'all' !== nodeId && 'scd' !== nodeId;
               };
               dz.onNodeOver = function(nodeData, source, e, data){
                 console.debug('dz over', data);
                 var node = me.getView().getRecord(nodeData);
                 if (node){
                    console.debug('node', node);
                    var nodeId = node.get('id');
                    if (this.isNodeIdValid(nodeId)){
                        console.debug('DnD allowed');
                        return this.dropAllowed;
                    }
                    }
                 console.debug('DnD rejected');
                 return this.dropNotAllowed;
               };
               dz.onNodeDrop = function(nodeData, source, e, data){
                   console.debug('dz node drop', data);
                   var node = me.getView().getRecord(nodeData);
                   if (node){
                       console.debug('drop on node', node);
                       var nodeId = node.get('id');
                       if (this.isNodeIdValid(nodeId)){
                           console.debug('dropped', data);
                           me.fireEvent('ontreenodedrop', node, data, me);
                           return true;
                       }
                   }
                   return false;
               };
            }, this);
        }

    },
    onItemContextMenu: function(tree, record, item, rowIndex, e){
        e.stopEvent();
        var coords = e.getXY();

        if (!tree.getSelectionModel().isSelected(rowIndex)) {
          tree.getSelectionModel().selectRow(rowIndex);
        }

        var menu = new Ext.menu.Menu({
          items: this.contextMenu
        });

        menu.showAt(coords);
      },
    onNewTopFolder: function(){
        var me = this;
        Ext.MessageBox.prompt('Категория', 'Введите имя новой категории:',
            function(btn, text){
                console.debug(btn, text);
                if (btn == 'ok'){
                    console.debug('new category');
                    me.newTopFolder({name: text});
                    me.store.load();
                }
            }
        );
    },
    onNewFolder: function(){
        var me = this;
        console.debug(me.getSelectionModel());
        if (me.getSelectionModel().hasSelection()){
            var parent = me.getSelectionModel().getSelection()[0];
            console.debug('selected', parent);
            var parentId = parent.get('id');
            if ((parentId === 'scd')||(parentId === 'all')){
                Ext.MessageBox.show({
                   title: 'Предупреждение',
                    msg: 'Данная папка не может содержать подпапки.',
                    buttons: Ext.Msg.OK,
                    icon: Ext.Msg.WARNING
                });
                return;
            }
            Ext.MessageBox.prompt('Папка', 'Введите имя новой папки:',
                function(btn, text){
                    if (btn === 'ok'){
                        console.debug('new folder');
                        me.newFolder({name: text, parent: parent.get('id')});
                        me.store.load(parent);
                    }
                }
            );
        }
    },
    onDelete: function(){
        var me = this;
        if (me.getSelectionModel().hasSelection()){
            var folder = me.getSelectionModel().getSelection()[0];
            var folderId = folder.get('id');
            if ((folderId === 'scd')||(folderId === 'all')){
                Ext.MessageBox.show({
                   title: 'Предупреждение',
                    msg: 'Данная папка не может быть удалена.',
                    buttons: Ext.Msg.OK,
                    icon: Ext.Msg.WARNING
                });
                return;
            }
            Ext.MessageBox.confirm('Папка', 'Удалить выбранную папку?', function(btn){
               if (btn == 'yes'){
                   me.removeFolder({folder_id: folder.get('id')});
                   me.store.load();
               }
            });
        }
    },
    onRefresh: function(){
        this.store.load();
    },
    viewConfig:{
        plugins:{
            ptype: 'treeviewdragdrop',
            ddGroup: 'ddActivities',
            enableDrag: false,
            appendOnly: true,
            pluginId: 'dragdrop'
        },
        listeners:{
            beforedrop: function(node, data, overModel, dropPosition, dropHandler, eOpts ){
               console.debug("over", node, data, overModel);
                var targetFolder = overModel.get('id');
                this.droppedRecords = data.records;
                data.records = [];
            },
            drop: function(node, data, dropRec, dropPosition){
                console.debug("drop", this.droppedRecords);
                this.droppedRecords = undefined;
            }
        }
    }
}