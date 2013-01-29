// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// code yanked from the Yahoo media player. Thanks, Yahoo.
if (! ("console" in window) || !("firebug" in console)) {
    var names = ["log", "debug", "info", "warn", "error", "assert", "dir", "dirxml", "group"
                 , "groupEnd", "time", "timeEnd", "count", "trace", "profile", "profileEnd"];
    window.console = {};
    for (var i = 0; i <names.length; ++i) window.console[names[i]] = function() {};
}

if (typeof(console.debug) !== 'function'){
    console.debug = function(){};
}

Ext.override(Ext.menu.KeyNav, {
    constructor: function(menu) {
        var me = this;


        me.menu = menu;
        me.callParent([menu.el, {
            down: me.down,
            enter: me.enter,
            esc: me.escape,
            left: me.left,
            right: me.right,
            //space: me.enter,
            tab: me.tab,
            up: me.up
        }]);
    }
});