#encoding: UTF-8
class PersonsGrid < Netzke::Basepack::GridPanel

  include ServiceCenter::Reportable

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
            {:name => :organization__name, :xtype => :hiddenfield},
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

  def deliver_component_endpoint(params)
    components[:reset_password_form][:items].first.merge!(:record_id => params[:record_id].to_i) if params[:name] == 'reset_password_form'
    super
  end

  def default_context_menu
    res = super
    res << "-" << :reset_password.action if @ability.can? :reset_password, Person
    res
  end

  def configuration
    @ability = Ability.new Netzke::Core.current_user
    super.tap do |c|
      c[:model] = "Person"
      c[:title] = Person.model_name.human({:count => 5})
      c[:prohibit_create] = @ability.cannot?(:create, Person)
      c[:prohibit_update] = @ability.cannot?(:update, Person)
      c[:prohibit_delete] = @ability.cannot?(:delete, Person)
      c[:enable_edit_in_form] = @ability.can?(:create, Person)
      c[:columns] = [
          {:name => :name},
          {:name => :username},
          {:name => :email},
          {:name => :organization__name},
          {:name => :position__name},
          {:name => :person_status__name},
          {:name => :last_sign_in_at, :read_only => true}
      ]
      c[:add_form_config] = {
          :class_name => "Netzke::Basepack::FormPanel",
          :items => [
              :name, :username, :email,
              {:name => :password, :input_type => :password},
              {:name => :password_confirmation, :input_type => :password},
              :organization__name, :position__name
          ]
      }
      if @ability.can? :print, :payments
        c[:tbar] = [
            {:text => 'Печать', :icon => :printer.icon, :name => :print, :menu => [:print_payments.action]},
            {:text => 'Месяц', :icon => :calendar.icon, :name => :month, :menu => [{:xtype => :datepicker, :name => :date}]}
          ]
      end
    end
  end

  action :print_payments do
    {
      :text => "Платежная ведомость",
      :icon => :coins
    }
  end

  js_mixin :persons_grid
  js_mixin :reset_password

end