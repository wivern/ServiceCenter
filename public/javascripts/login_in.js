/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 16.02.12
 * Time: 10:49
 * To change this template use File | Settings | File Templates.
 */
Ext.create('Ext.panel.Panel',{
   preventHeader: true,
    width: 355,
    shadow: true,
    bodyPadding: 5,
    html: '<div><p>Для регистрации в демо-режиме доступны следующие учетные записи и пароли:</p>' +
        '<ul><li>acceptor - приемщик</li> <li>service  - сервис-инженер</li> <li>manager  - менеджер</li>' +
        '<li>director - директор</li></ul><p>Для всех учетных записей установлен пароль <b>123123</b>.</p></div>',
    renderTo: Ext.getBody()
});