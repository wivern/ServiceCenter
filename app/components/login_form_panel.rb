class LoginFormPanel < Netzke::Basepack::FormPanel

  js_property :url, "/person/sign_in"
  js_property :title, "Авторизация"

  js_mixin :login_form_panel

  action :login do
    {
        :text => I18n.t('views.forms.login_form_panel.actions.login.text'),
        :tooltip => I18n.t('views.forms.login_form_panel.actions.login.tooltip'),
        :icon => :key
    }
  end

  def configuration
    super.merge(
        {
            :frame => true,
            :field_defaults => {
                :label_width => 80
            }
        }
    )
  end

  def configure_bbar(c)
    c[:bbar] = [:login.action]
  end

  js_method :on_apply, <<-JS
    function(e){}
  JS

  js_method :on_login, <<-JS
    function(e){
      var values = this.getForm().getFieldValues();
      this.submit({
        params: {
          format: 'json',
          'person[username]': values.username,
          'person[password]': values.password
        },
          method: 'POST',
        success: function(form, action){
          location.href = '/';
        },
        failure: function(form, action){
          switch(action.failureType){
            case Ext.form.action.Action.CLIENT_INVALID:
                Ext.Msg.alert('Failure', 'Form fields may not be submitted with invalid values');
                break;
            case Ext.form.action.Action.CONNECT_FAILURE:
                Ext.Msg.alert('Failure', 'Неверное имя или пароль');
                break;
            case Ext.form.action.Action.SERVER_INVALID:
               Ext.Msg.alert('Failure', action.result.msg);
          }
        }
      });
    }
  JS


end