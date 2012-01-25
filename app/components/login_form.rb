#encoding: UTF-8
class LoginForm < Netzke::Base

  js_base_class "Ext.window.Window"

  js_mixin

  js_property :title, I18n.t('views.forms.login_form_panel.title')

  component :login_panel do
    {
        :url => '/people/sign_in',
        :class_name => 'LoginFormPanel',
        :model => 'Person',
        :items => [
            { :field_label => Person.human_attribute_name('username'), :name => :username},
            {
                :field_label => Person.human_attribute_name('password'),
                :name => :password,
                :input_type => :password
            }
        ]
    }
  end

  def configuration
    super.tap do |s|
      s[:items] = [:login_panel.component(:prevent_header => true)]
    end
  end

end