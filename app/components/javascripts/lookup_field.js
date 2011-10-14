/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 11.10.11
 * Time: 17:03
 * To change this template use File | Settings | File Templates.
 */

Ext.namespace('Ext.ux');

Ext.define('Ext.netzke.lookupField', {
    extend: 'Ext.form.field.Trigger',
    alias:  'widget.lookupfield',

    initComponent: function(){
        this.callParent();
    },

    onTriggerClick: function() {
        Ext.Msg.alert('Status', 'You clicked my trigger!');
    }
  });
