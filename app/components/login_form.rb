class LoginForm < Netzke::Base

  js_base_class "Ext.window.Window"

  js_mixin

  component :login_panel do
    {
        :url => '/login.json',
        :class_name => 'LoginFormPanel',
        :model => 'Person',
        :items => [
            :username,
            {
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