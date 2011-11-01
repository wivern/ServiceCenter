/**
 * Created by JetBrains RubyMine.
 * User: vitaly
 * Date: 31.10.11
 * Time: 14:12
 * To change this template use File | Settings | File Templates.
 */
{
    defaults : {
        listeners:{
            specialkey: {
                fn: function(f,e) {
                    if (e.getKey() == 13)
                        this.ownerCt.onLogin();
                    }
            }
        }
    }
}