#encoding: UTF-8
class OrderDetailsPanel < Netzke::Basepack::FormPanel

  include ServiceCenter::ExtendedForm

  def configuration
    super.merge(
      :model => "Order",
      :record_id => session[:selected_order_id],
      :items => [
          {
              :xtype => :tabpanel, :flex => 1, :align => "stretch", :body_padding => 5, :plain => true, :active_tab => 0,
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
                                    {:name => :product_passport__producer__name},
                                    {:name => :product_passport__product_name__name},
                                    {:name => :product_passport__factory_number},
                                    {:name => :product_passport__guarantee_stub_number},
                                    {:name => :product_passport__purchase_place__name},
                                    {:name => :product_passport__purchased_at, :xtype => :datefield, :read_only => true},
                                    {:name => :product_passport__dealer__name}
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
                                                  {:name => :complects__name, :xtype => :netzkeboxselect, :editable => false,
                                                    :hide_trigger => true, :height => 110, :auto_load_store => true},
                                                  {:name => :reason__name, :xtype => :textarea},
                                                  {:name => :internal_state__name, :xtype => :textarea},
                                                  {:name => :external_state__name, :xtype => :textarea}
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
                                      { :name => :customer__name, :xtype => :displayfield },
                                      { :name => :customer__address, :xtype => :displayfield },
                                      { :name => :customer__phone, :xtype => :displayfield },
                                      { :name => :customer__email, :xtype => :displayfield },
                                      { :name => :customer__passport, :xtype => :displayfield }
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
                                        {:name => :diag_price},
                                        {:name => :diag_ground},
                                        {:name => :diagnosed_at},
                                        {:name => :actual_defect, :flex => 2, :xtype => :textarea}
                                    ]
                                },
                                {
                                    :flex => 1, :border => false, :defaults => {:anchor => "100%"},
                                    :items => [
                                        {:name => :goal__name, :xtype => :textarea},
                                        {:name => :result__name, :xtype => :textarea}
                                    ]
                                }
                            ]
                          }
                      ]
                  },
                  {
                      :title => "Работы"
                  },
                  {
                      :title => "Детали"
                  },
                  {
                      :title => "Скидка"
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

  #endpoint :get_print_options do |params|
  #  reports = Report.all.map{ |r|  {:text => r.name, :reportId => r.friendly_url} }
  #  {:set_result => reports}
  #end

  #js_method :on_cancel, <<-JS
  #  function(){
  #    this.getForm().reset();
  #  }
  #JS

end