#encoding: UTF-8
class AddOrderForm < Netzke::Basepack::FormPanel

  js_include "#{File.dirname(__FILE__)}/javascripts/lookup_field.js"

  def default_config
    super.merge(:model => "Order")
  end

  def configuration
    super.tap do |s|
      configure_locked(s)
      configure_bbar(s)
      product_passport_fields = [
          {:name => :product_passport__factory_number},
          {:name => :product_passport__producer__name, :xtype => :textfield, :read_only => true},
          {:name => :product_passport__product_name__name, :read_only => true},
          {:name => :product_passport__guarantee_stub_number, :xtype => :textfield, :readOnly => true},
          {:name => :product_passport__purchase_place__name},
          {:name => :product_passport__purchased_at, :xtype => :datefield},
          {:name => :product_passport__dealer__name}]
      customer_fields = [
          {:name => :customer__name, :xtype => :lookupfield},
          :customer__phone,
          :customer__email,
          :customer__passport
      ]
      s[:items] = [
          {
              :layout => {:type => 'table', :columns => 2}, :defaults => {:border => false},
              :cls => "x-table-layout-cell-top",
              :border => false, :flex => 1, :plain => true,
              :items => [
                  {:name => :repair_type__name, :colspan => 2},
                  {
                      :xtype => :fieldset,
                      :title => I18n.t('views.forms.add_order.product_passport'),
                      :items => product_passport_fields,
                      :flex => 1
                  },
                  {
                      :xtype => :fieldset,
                      :title => I18n.t('views.forms.add_order.customer'),
                      :items => customer_fields,
                      :flex => 1,
                      :style => 'margin: 0 5px;valign: top;'
                  },
                  {
                      :xtype => :fieldset,
                      :title => I18n.t('views.forms.add_order.order_details'),
                      :colspan => 2,
                      :items => {
                          :xtype => :panel, :layout => :hbox, :border => false, :defaults => {:border => false},
                          :items => [
                              {# 1st column
                               :flex => 1, :defaults => {:anchor => '-8'},
                               :items => [
                                   {:field_label => "Complect", :name => :complect__name, :xtype => :textarea},
                                   {:field_label => "External state", :name => :external_state__name, :xtype => :textarea}
                               ]
                              },
                              {# 2nd column
                               :flex => 1, :defaults => {:anchor => '100%'},
                               :items => [
                                   {:field_label => Order.human_attribute_name("defect"), :name => :defect__name, :xtype => :textarea},
                                   {:field_label => Order.human_attribute_name("diag_price"), :name => :diag_price, :xtype => :numberfield},
                                   {:field_label => Order.human_attribute_name("prior_cost"), :name => :prior_cost, :xtype => :numberfield},
                                   {:field_label => Order.human_attribute_name('maximum_cost'), :name => :maximum_cost, :xtype => :numberfield}
                               ]
                              }
                          ]
                      }
                  }
              ]
          }
      ]
    end
  end

  def netzke_submit(params)
    super
  end

end