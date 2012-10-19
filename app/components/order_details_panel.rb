#encoding: UTF-8
class OrderDetailsPanel < Netzke::Basepack::FormPanel

  include ServiceCenter::ExtendedForm

  component :select_external_state do
    {
        :class_name => "DictionaryWindow",
        :model => "ExternalState",
        :prohibit_modify => true,
        :initial_sort => %w('name' 'ASC')
    }
  end

  component :select_defect do
    {
        :class_name => "DictionaryWindow",
        :model => "Defect",
        :columns => [:name],
        :prohibit_modify => false,
        :initial_sort => %w('name' 'ASC')
    }
  end

  component :select_internal_state do
    {
        :class_name => "DictionaryWindow",
        :model => "InternalState",
        :columns => [:name],
        :prohibit_modify => true,
        :initial_sort => %w('name' 'ASC')
    }
  end

  component :select_ground do
    {
        :class_name => "DictionaryWindow",
        :model => "Ground",
        :columns => [:name],
        :prohibit_modify => false,
        :initial_sort => %w('name' 'ASC')
    }
  end

  component :select_goal do
    {
        :class_name => "DictionaryWindow",
        :model => "Goal",
        :columns => [:name],
        :prohibit_modify => false,
        :initial_sort => %w('name' 'ASC')
    }
  end

  component :select_person do
    {
        :class_name => "DictionaryWindow",
        :model => "Person",
        :columns => [:name, :login],
        :prohibit_modify => false,
        :initial_sort => %w('name' 'ASC')
    }
  end

  component :select_diagnostic_activity do
    {
        :class_name => "SelectDiagnosticActivityWindow",
        :initial_sort => %w('name' 'ASC')
    }
  end

  component :activities do
    {
        :class_name => "ActivitiesGrid",
        :strong_default_attrs => {:order_id => config[:record_id]},
        :scope => ["order_id = ?", config[:record_id]],
        :order_id => config[:record_id],
        :prevent_header => true,
        :min_height => 300
    }
  end

  component :parts do
    {
        :class_name => "PartsGrid",
        :strong_default_attrs => {:order_id => config[:record_id]},
        :scope => ["order_id = ?", config[:record_id]],
        :order_id => config[:record_id],
        :prevent_header => true
    }
  end

  DIAG_FIELD_WIDTH = 450

  def configuration
    @user = Netzke::Core.current_user
    @ability = Ability.new @user
    general_tabs = [
                                      { :title => "Начальные сведения",  :flex => 1,
                                        :items => [
                                          {:name => :repair_type__name, :read_only => true},
                                          {:name => :number, :read_only => true},
                                          {:name => :ticket, :read_only => true},
                                          {:name => :status__name},
                                          {:name => :manager__display_name, :xtype => :textfield, :read_only => true, :width => 300}
                                      ]},
                                      { :title => "Паспорт изделия", :defaults => {:read_only => true, :xtype => :textfield},
                                        :items => [
                                            {:name => :product_passport__producer__name, :read_only => true},
                                            {:name => :product_passport__product__name, :read_only => true},
                                            {:name => :product_passport__factory_number, :read_only => true},
                                            {:name => :product_passport__guarantee_stub_number, :read_only => true},
                                            {:name => :product_passport__purchase_place__name, :read_only => true},
                                            {:name => :product_passport__purchased_at_str, :read_only => true,
                                              :format => 'd.m.Y', :submit_format => 'Y-m-d'}, #:xtype => :datefield, :format => 'd.m.y'
                                            {:name => :product_passport__dealer__name, :read_only => true}
                                        ]
                                      },
                                      {
                                          :title => "Атрибуты заказа",
                                          :items => [{
                                              :layout => :hbox, :border => false, :defaults => {:border => false},
                                              :items => [
                                                  {
                                                      :flex => 1, :defaults => {:anchor => "-8"},
                                                      :items => [
                                                          {:name => :complects__name, :xtype => :netzkeboxselect, :read_only => true,
                                                            :hide_trigger => true, :height => 110, :auto_load_store => true},
                                                          {:name => :defects__name, :xtype => :netzkeboxselect, :read_only => true,
                                                            :hide_trigger => true, :height => 140, :auto_load_store => true},
                                                          {:name => :defect_note, :xtype => :textarea, :height => 140, :read_only => true}
                                                      ]
                                                  },
                                                  {
                                                      :flex => 1, :border => false, :defaults => {:anchor => "100%"},
                                                      :items => [
                                                          {:name => :applied_at, :format => 'd.m.Y'},
                                                          {:name => :plan_deliver_at, :format => 'd.m.Y'},
                                                          {:name => :actual_deliver_at, :format => 'd.m.Y'},
                                                          {:name => :deliver_manager__name, :scope => :active_and_in_current_organization},
                                                          {:name => :guarantee_case, :xtype => :numericfield},
                                                          {:name => :external_states__name, :xtype => :netzkepopupselect, :height => 140,
                                                            :auto_load_store => true, :selection_component => :select_external_state},
                                                          {:name => :external_state_note, :xtype => :textarea, :height => 140},
                                                          {:name => :order_location__name}
                                                      ]
                                                  }
                                              ]
                                          }]
                                      }
                                  ]
    general_tabs << {
                                              :flex => 1,
                                              :title => "Заказчик",
                                              :items => [
                                                  :layout => :anchor, :border => false, :defaults => {:anchor => '50%'},
                                                  :items => [
                                                    { :name => :customer__name, :anchor => "60%", :read_only => true },
                                                    { :name => :customer__address, :anchor => "100%", :read_only => true },
                                                    { :name => :customer__phone, :read_only => true },
                                                    { :name => :customer__email, :read_only => true },
                                                    { :name => :customer__passport, :read_only => true }
                                                  ]
                                              ]
                                          } if @ability.can :see_customer_in_order
    general_items = [
                              {:xtype => :tabpanel, :align => "stretch", :body_padding => 5, :plain => true, :active_tab => 0,
                              :items => general_tabs}
                          ]
    cost_tab = {
                          :title => "Стоимость",
                          :items => [
                            {:name => :total_amount, :xtype => :numericfield, :read_only => true,
                              :currency_symbol => 'руб.', :currency_at_end => true},
                            {:name => :discount, :xtype => :numericfield},
                            {:name => :discount_type, :xtype => :combo,
                              :store => Order.discount_types.map{ |k,v| [k,v]}},
                            {:name => :discount_ground, :xtype => :textarea},
                            {:name => :total_amount_with_discount, :xtype => :numericfield, :read_only => true,
                                                      :currency_symbol => 'руб.', :currency_at_end => true}
                          ]
                      }
    service_tab = {
                          :title => "Сервис",
                          :items => [
                              {
                                  :layout => :hbox, :align => "stretch", :pack => 'start', :border => false, :items => [
                                  {
                                      :flex => 1, :border => false, :defaults => {:anchor => "-8"},
                                      :items => [
                                          {:name => :service_info }
                                      ]
                                  },
                                  {
                                      :flex => 1, :border => false, :defaults => {:anchor => "-8"}, :items => [
                                        {:name => :service_state},
                                        {:name => :service_note},
                                        :service_phone_agreement
                                    ]
                                  }
                                ]
                              }
                          ]
                      }
    diagnostic_1_items = [ {:name => :diag_manager__name} ]
    diagnostic_1_items << {:field_label => Order.human_attribute_name("diag_price"), :name => :diagnostic_activity__price,
        :xtype => :selecttriggerfield, :selection_component => :select_diagnostic_activity,
        :display_field => :name} #unless @user.has_role_engineer?
    diagnostic_1_items << {:name => :diagnosed_at} << {:name => :actual_defect, :xtype => :textarea, :height => 140, :width => DIAG_FIELD_WIDTH}
    diagnostic_1_items << {:name => :internal_states__name, :xtype => :netzkepopupselect, :height => 140, :width => DIAG_FIELD_WIDTH,
      :auto_load_store => true, :selection_component => :select_internal_state}


    order_diagnostic_tab = {
                              :title => "Диагностика",
                              :items => [
                                  {
                                      :layout => :hbox, :align => "stretch", :border => false, :flex => 1, :items => [
                                        {
                                            :flex => 1, :border => false, :defaults => {:anchor => "-8"},
                                            :items => diagnostic_1_items
                                        },
                                        {
                                            :flex => 1, :border => false, :defaults => {:anchor => "100%"},
                                            :items => [
                                                #{:name => :goals__name, :xtype => :netzkepopupselect, :height => 140,
                                                #  :selection_component => :select_goal, :auto_load_store => true},
                                                {:name => :result, :xtype => :textarea, :height => 160, :width => DIAG_FIELD_WIDTH}
                                            ]
                                        }
                                    ]
                                  }
                              ]
                          }
    order_tabs = [
                      {
                          :title => "Сведения",
                          :items => general_items
                      },
                      order_diagnostic_tab,
                      {
                          :title => I18n.t('activerecord.models.activity'),
                          :items => [
                              :activities.component(:title => "Работы"),
                              { :layout => :fit, :border => false,
                                :bodyPadding => "10 0 0 0",
                                :items => [
                                  {:name => :work_performed_at, :format => "d.m.y"},
                                  {:name => :engineer__name, :xtype => :selecttriggerfield,
                                    :selection_component => :select_person, :auto_load_store => true}
                                  #{:name => :prior_cost, :xtype => :numericfield, :currency_symbol => 'руб.', :currency_at_end => true,
                                  #        :allow_negative => false, :step => 10},
                                  #{:name => :maximum_cost, :xtype => :numericfield, :currency_symbol => 'руб.', :currency_at_end => true,
                                  #        :allow_negative => false, :step => 10}
                                ]
                              }
                          ]
                      },
                      :parts.component(:title => I18n.t('activerecord.models.spare_part'))
                  ]
    order_tabs << cost_tab if @user.has_no_role_engineer?
    order_tabs << service_tab
    super.merge(
      :model => "Order",
      #:record_id => session[:selected_order_id],
      :items => [
          {
              :xtype => :tabpanel, :flex => 1, :align => "stretch", :body_padding => 5, :plain => true, :active_tab => 0,
              :layout => :fit,
              :items => order_tabs
          }
      ]
    )
  end

  include ServiceCenter::Reportable

  action :print, :icon => :printer

  action :recalc, :icon => :calculator

  js_mixin :order_details_panel

  js_property :allow_multi, true

  endpoint :recalc do |params|
    orderId = params[:orderId]
    order = Order.find(orderId) #what if not found?
    {:set_form_values =>
        { :total_amount => order.total_amount,
            :total_amount_with_discount => order.total_amount_with_discount
        }.literalize_keys, :set_result => true
    }
  end

  #js_include "#{File.dirname(__FILE__)}/javascripts/print.js"
  def configure
    super
    @user = Netzke::Core.current_user
    @ability = Ability.new @user
  end

  def configure_bbar(c)
    user = Netzke::Core.current_user
    c[:bbar] = [:apply.action]
    if user.has_no_role_engineer?
      c[:bbar] << {:text => 'Печать', :icon => '/images/icons/printer.png', :name => 'print', :menu => []}
      c[:bbar] << :recalc.action
    end
  end

  def netzke_submit(params)
    data = ActiveSupport::JSON.decode(params[:data])

    # File uploads are in raw params instead of "data" hash, so, mix them in into "data"
    if config[:file_upload]
      Netzke::Core.controller.params.each_pair do |k,v|
        data[k] = v if v.is_a?(ActionDispatch::Http::UploadedFile)
      end
    end

    #data.symbolize_keys!
    #Engineer
    data[:engineer.to_s] = Person.find(data[:engineer.to_s]) if data[:engineer.to_s]

    begin
      success = create_or_update_record(data)
    rescue Exception => e
      logger.error e.message
      success = false
      flash :error => "Ошибка сохранения данных"
    end

    if success
      flash :notice => I18n.t("form_saved")
      {:set_form_values => js_record_data, :netzke_feedback => @flash, :set_result => true}
    else
      # flash eventual errors
      @record.errors.to_a.each do |msg|
        flash :error => msg
      end
      {:netzke_feedback => @flash, :apply_form_errors => build_form_errors(record)}
    end
  end

end