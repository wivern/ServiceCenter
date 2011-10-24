#encoding: UTF-8
class AddOrderForm < Netzke::Basepack::FormPanel

  js_include "#{File.dirname(__FILE__)}/javascripts/lookup_field.js"
  js_include "#{File.dirname(__FILE__)}/javascripts/autosuggest.js"

  endpoint :get_auto_suggest do |params|
    query = params[:query]

    field = fields[params[:column].to_sym]
    scope = field.to_options[:scope]
    query = params[:query]
    {:data => get_autosuggest_values(field, :query => query, :scope => scope, :record_id => params[:id])}
  end

  endpoint :load_associated_data do |params|
    field = fields[params[:column].to_sym]
    record_id = params[:selected]
    { :set_result => load_assoc_record(field, record_id) }
  end

  def default_config
    super.merge(:model => "Order")
  end

  def configuration
    super.tap do |s|
      configure_locked(s)
      configure_bbar(s)
      product_passport_fields = [
          {:name => :product_passport__factory_number, :xtype => :autosuggest, :populate_related_fields => true},
          {:name => :product_passport__producer__name, :xtype => :autosuggest},
          {:name => :product_passport__product_name__name, :xtype => :autosuggest, :minChars => 1},
          {:name => :product_passport__guarantee_stub_number, :xtype => :textfield},
          {:name => :product_passport__purchase_place__name, :xtype => :autosuggest},
          {:name => :product_passport__purchased_at, :xtype => :datefield},
          {:name => :product_passport__dealer__name, :xtype => :autosuggest}]
      customer_fields = [
          {:name => :customer__name, :xtype => :autosuggest, :populate_related_fields => true},
          {:name => :customer__phone, :xtype => :textfield },
          {:name => :customer__email, :xtype => :textfield },
          {:name => :customer__passport, :xtype => :textfield }
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

  def normalize_field_with_suggest(field)
    field = normalize_field_without_suggest(field)
    field[:parent_id] = self.global_id if field[:xtype] == :autosuggest

    field
  end

  alias_method_chain :normalize_field, :suggest

  def netzke_submit(params)
    super
  end

  protected
  def all_association_syms(assoc)
    assoc.klass.reflect_on_all_associations.map{|k| k.name.to_sym}
  end

  def load_assoc_record(field, record_id)
    assoc, assoc_method = assoc_and_assoc_method_for_attr(field)
    if assoc
      relation = assoc.klass.scoped
      includes = all_association_syms(assoc)
      logger.debug("Associations " + includes.inspect)
      relation.includes(includes).find(record_id).to_json(:include => includes)
    end
  end

  def get_autosuggest_values(field, options = {})
    query = options[:query]
    assoc, assoc_method = nested_assoc_and_assoc_method_for_attr(field)
    if assoc
      # Options for an asssociation attribute

      relation = assoc.klass.scoped

      relation = relation.extend_with(options[:scope]) if options[:scope]

      if assoc.klass.column_names.include?(assoc_method)
        # apply query
        relation = relation.where("#{assoc_method} like ?", "#{query}%") if query.present?
        relation.all.map{ |r| [r.id, r.send(assoc_method)] }
      else
        relation.all.map{ |r| [r.id, r.send(assoc_method)] }.select{ |id,value| value =~ /^#{query}/ }
      end
    end
  end

  def nested_assoc_and_assoc_method_for_attr(c)
    fields = c[:name].split('__')
    assoc, assoc_method = fields[-2, 2]
    if (assoc_method)
      assoc = data_class
      (fields - [assoc_method]).each{ |i|
        if assoc.respond_to? :reflect_on_association
          assoc = assoc.reflect_on_association(i.to_sym)
        else
          assoc = Kernel.const_get(assoc.class_name).reflect_on_association(i.to_sym)
        end
      }
    end
    [assoc, assoc_method]
  end

end