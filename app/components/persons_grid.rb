class PersonsGrid < Netzke::Basepack::GridPanel

  action :reset_password do
    {
        :text => I18n.t('views.actions.reset_password.text'),
        :tooltip => I18n.t('views.actions.reset_password.tooltip'),
        :icon => :lock_edit
    }
  end

  component :reset_password_form do
    form_config = {
        :class_name => "Netzke::Basepack::FormPanel",
        :model => "Person",
        :prevent_header => true,
        :bbar => false,
        :items => [
            {:name => :name},
            {:name => :email, :xtype => :hiddenfield},
            {:name => :username, :xtype => :hiddenfield},
            {:name => :password, :input_type => :password},
            {:name => :password_confirmation, :input_type => :password}
        ],
        :title => I18n.t('views.actions.reset_password.text')
    }

    {
      :lazy_loading => true,
      :class_name => "Netzke::Basepack::GridPanel::RecordFormWindow",
      :title => "Edit #{data_class.model_name.human}",
      :button_align => "right",
      :items => [form_config]
    }.deep_merge(config[:edit_form_window_config] || {})
  end

  def default_context_menu
    res = super
    res << "-" << :reset_password.action #if administrator
    res
  end

  def configuration
    super.merge(
      :model => "Person",
      :title => Person.model_name.human({:count => 5}),
      :columns => [
          {:name => :name},
          {:name => :username},
          {:name => :email},
          {:name => :organization__name},
          {:name => :position__name},
          {:name => :last_sign_in_at, :read_only => true}
      ],
      :add_form_config => {
          :class_name => "Netzke::Basepack::FormPanel",
          :items => [
              :name, :username, :email,
              {:name => :password, :input_type => :password},
              {:name => :password_confirmation, :input_type => :password},
              :organization__name, :position__name
          ]
      }
    )
  end

  js_mixin :reset_password

end