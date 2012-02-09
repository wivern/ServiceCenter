/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 09.02.12
 * Time: 15:38
 * To change this template use File | Settings | File Templates.
 */
var exportForm;

Ext.onReady(function(){
    var body = Ext.getBody();

    var frame = body.createChild({
        tag:'iframe'
        ,cls:'x-hidden'
        ,id:'export-iframe'
        ,name:'export-iframe'
    });

    exportForm = body.createChild({
        tag: 'form',
        cls: 'x-hidden',
        id: 'export-form',
        action: '/analytics.csv',
        target: 'export-iframe'
    });
});