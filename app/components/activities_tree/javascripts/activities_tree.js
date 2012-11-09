/**
 * User: vitaly
 * Date: 09.11.12
 * Time: 15:40
 */

{
    initComponent: function(){
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
        this.callParent();
    }
}