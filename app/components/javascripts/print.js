/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 08.11.11
 * Time: 14:01
 * To change this template use File | Settings | File Templates.
 */
var printForm;

Ext.onReady(function() {
    var body = Ext.getBody();

    var frame = body.createChild({
        tag:'iframe'
        ,cls:'x-hidden'
        ,id:'print-iframe'
        ,name:'print-iframe'
    });

    printForm = body.createChild({
        tag: 'form',
        cls: 'x-hidden',
        id: 'print-form',
        action: '/print/ticket/35',
        target: 'print-iframe'
    });
});