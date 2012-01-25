#encoding: UTF-8
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
        url: '/people/sign_in',
        params: {
          format: 'json',
          'person[username]': values.username,
          'person[password]': values.password
        },
        method: 'POST',
        success: function(form, action){
          if (Ext.isIE){
            Ext.Msg.alert('Предупреждение', 'Программа определила что Вы используете браузер IE' +
              Ext.ieVersion + "." +
              'Для удобной работы рекомендуется использовать FireFox 9 или выше или Chrome 11 или выше.');
          }
          location.href = '/';
        },
        failure: function(form, action){
          console.debug(action.response);
          var result = Ext.JSON.decode(action.response.responseText, true);
          console.debug('failure action', result);
          var msg = '';
          switch(result.error){
            case "invalid":
              msg = 'Неверное имя или пароль';
              break;
            case "inactive":
              msg = 'Учетная запись заблокирована.';
              break;
            default:
              msg = 'Неизвестная ошибка, повторите попытку позднее.';
              break;
          }
          Ext.Msg.show({
            title: 'Ошибка',
            msg: msg,
            buttons: Ext.Msg.OK,
            icon: Ext.MessageBox.ERROR
          });
        }
      });
    }
  JS


end