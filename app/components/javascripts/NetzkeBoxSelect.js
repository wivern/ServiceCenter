/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 27.10.11
 * Time: 16:14
 * To change this template use File | Settings | File Templates.
 */
Ext.define('Ext.netzke.BoxSelect',{
    extend: 'Ext.ux.form.field.BoxSelect',
    alias: 'widget.netzkeboxselect',
    growMin: 75,
    growMax: 75,
    createNewOnEnter: true,
    createNewOnBlur: true,
    forceSelection: false,
    hideTrigger: true,
    minChars: 1,
    delimiter: ',',
    valueField: 'value',
    displayField: 'value',
    emptyText: 'Type a name of component',
    mixins: {
      storable: 'Ext.netzke.Storable'
    },
    initComponent: function(){
        this.initStore();
        this.callParent(arguments);
    }
});