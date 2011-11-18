/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 18.11.11
 * Time: 16:10
 */

Ext.apply(Ext.form.field.VTypes,{
   reference: function(v){
       console.debug("validating", v);
       return /^\d+$/.test(v);
   },
    referenceText: 'Выберите значение из списка.'
});