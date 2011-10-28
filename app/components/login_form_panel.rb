class LoginFormPanel < Netzke::Basepack::FormPanel


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
      this.submit({
        params: { format: 'json' }
      });
    }
  JS


end