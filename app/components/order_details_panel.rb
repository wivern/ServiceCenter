#encoding: UTF-8
class OrderDetailsPanel < Netzke::Basepack::FormPanel

  include ServiceCenter::ExtendedForm

  component :select_external_state do
    {
        :class_name => "DictionaryWindow",
        :model => "ExternalState",
        :prohibit_modify => true,
        :initial_sort => ['name', 'ASC']
    }
  end

  component :select_defect do
    {
        :class_name => "DictionaryWindow",
        :model => "Defect",
        :columns => [:name],
        :prohibit_modify => false,
        :initial_sort => ['name', 'ASC']
    }
  end

  component :select_internal_state do
    {
        :class_name => "DictionaryWindow",
        :model => "InternalState",
        :columns => [:name],
        :prohibit_modify => true,
        :initial_sort => ['name', 'ASC']
    }
  end

  component :select_ground do
    {
        :class_name => "DictionaryWindow",
        :model => "Ground",
        :columns => [:name],
        :prohibit_modify => false,
        :initial_sort => ['name', 'ASC']
    }
  end

  component :select_goal do
    {
        :class_name => "DictionaryWindow",
        :model => "Goal",
        :columns => [:name],
        :prohibit_modify => false,
        :initial_sort => ['name', 'ASC']
    }
  end

  component :activities do
    {
        :class_name => "ActivitiesGrid",
        :strong_default_attrs => {:order_id => config[:record_id]},
        :scope => ["order_id = ?", config[:record_id]],
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

  def configuration
    super.merge(
      :model => "Order",
      #:record_id => session[:selected_order_id],
      :items => [
          {
              :xtype => :tabpanel, :flex => 1, :align => "stretch", :body_padding => 5, :plain => true, :active_tab => 0,
              :layout => :fit,
              :items => [
                  {
                      :title => "Сведения",
                      :items => [
                          {:xtype => :tabpanel, :align => "stretch", :body_padding => 5, :plain => true, :active_tab => 0,
                          :items => [
                              { :title => "Начальные сведения",  :flex => 1,
                                :items => [
                                  {:name => :repair_type__name, :xtype => :displayfield},
                                  {:name => :number, :xtype => :displayfield},
                                  {:name => :ticket, :xtype => :displayfield},
                                  {:name => :manager__display_name, :xtype => :textfield, :read_only => true, :width => 300}
                              ]},
                              { :title => "Паспорт изделия", :defaults => {:read_only => true, :xtype => :textfield},
                                :items => [
                                    {:name => :product_passport__producer__name, :read_only => true},
                                    {:name => :product_passport__product__name, :read_only => true},
                                    {:name => :product_passport__factory_number, :read_only => true},
                                    {:name => :product_passport__guarantee_stub_number, :read_only => true},
                                    {:name => :product_passport__purchase_place__name, :read_only => true},
                                    {:name => :product_passport__purchased_at, :xtype => :datefield, :read_only => true},
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
                                                  {:name => :internal_states__name, :xtype => :netzkepopupselect, :height => 140,
                                                    :auto_load_store => true, :selection_component => :select_internal_state},
                                                  {:name => :external_states__name, :xtype => :netzkepopupselect, :height => 140,
                                                    :auto_load_store => true, :selection_component => :select_external_state}
                                              ]
                                          },
                                          {
                                              :flex => 1, :border => false, :defaults => {:anchor => "100%"},
                                              :items => [
                                                  {:name => :applied_at},
                                                  {:name => :plan_deliver_at},
                                                  {:name => :actual_deliver_at},
                                                  {:name => :deliver_manager__name},
                                                  {:name => :guarantee_case}
                                              ]
                                          }
                                      ]
                                  }]
                              },
                              {
                                  :flex => 1,
                                  :title => "Заказчик",
                                  :items => [
                                      { :name => :customer__name, :read_only => true },
                                      { :name => :customer__address, :read_only => true },
                                      { :name => :customer__phone, :read_only => true },
                                      { :name => :customer__email, :read_only => true },
                                      { :name => :customer__passport, :read_only => true }
                                  ]
                              }
                          ]}
                      ]
                  },
                  {
                      :title => "Диагностика",
                      :items => [
                          {
                              :layout => :hbox, :align => "stretch", :border => false, :flex => 1, :items => [
                                {
                                    :flex => 1, :border => false, :defaults => {:anchor => "-8"},
                                    :items => [
                                        {:name => :diag_manager__name},
                                        {:name => :diag_price, :xtype => :numericfield, :currency_at_end => true,
                                          :currency_symbol => 'руб.', :step => 10}, #TODO get currency from current locale
                                        {:name => :grounds__name, :xtype => :netzkepopupselect, :height => 140,
                                          :selection_component => :select_ground, :auto_load_store => true},
                                        {:name => :diagnosed_at},
                                        {:name => :actual_defect, :xtype => :textarea, :height => 140}
                                    ]
                                },
                                {
                                    :flex => 1, :border => false, :defaults => {:anchor => "100%"},
                                    :items => [
                                        {:name => :goals__name, :xtype => :netzkepopupselect, :height => 140,
                                          :selection_component => :select_goal, :auto_load_store => true},
                                        {:name => :result, :xtype => :textarea, :height => 160}
                                    ]
                                }
                            ]
                          }
                      ]
                  },
                      :activities.component(:title => "Работы"),
                      :parts.component(:title => I18n.t('activerecord.models.spare_part')),
                  {
                      :title => "Скидка",
                      :items => [
                        {:name => :discount, :xtype => :numericfield},
                        {:name => :discount_type, :xtype => :combo,
                          :store => Order.discount_types.map{ |k,v| [k,v]}},
                        {:name => :discount_ground, :xtype => :textarea}
                      ]
                  },
                  {
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
                                    {:name => :service_note}
                                ]
                              },
                              {
                                  :flex => 1, :border => false, :defaults => {:anchor => "100%"}, :items => [
                                    {:name => :service_phone_agreement}
                                ]
                              }
                            ]
                          }
                      ]
                  }
              ]
          }
      ]
    )
  end

  include ServiceCenter::Reportable

  action :print, :icon => :printer

  js_mixin :order_details_panel

  js_property :allow_multi, true

  #js_include "#{File.dirname(__FILE__)}/javascripts/print.js"

  def configure_bbar(c)
    c[:bbar] = [:apply.action, {:text => 'Печать', :icon => '/images/icons/printer.png', :name => 'print', :menu => []}]
  end

  def netzke_submit(params)
    data = ActiveSupport::JSON.decode(params[:data])

    # File uploads are in raw params instead of "data" hash, so, mix them in into "data"
    if config[:file_upload]
      Netzke::Core.controller.params.each_pair do |k,v|
        data[k] = v if v.is_a?(ActionDispatch::Http::UploadedFile)
      end
    end

    success = create_or_update_record(data)

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