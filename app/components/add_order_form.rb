#encoding: UTF-8
class AddOrderForm < Netzke::Basepack::FormPanel

  #js_include "#{File.dirname(__FILE__)}/javascripts/lookup_field.js"
  js_include "#{File.dirname(__FILE__)}/javascripts/netzke_storable.js" #TODO move to app global definitions
  js_include "#{File.dirname(__FILE__)}/javascripts/autosuggest.js"
  js_include "#{File.dirname(__FILE__)}/javascripts/BoxSelect.js"
  js_include "#{File.dirname(__FILE__)}/javascripts/NetzkeBoxSelect.js"

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
          {:name => :product_passport__factory_number, :xtype => :autosuggest, :populate_related_fields => true, :allow_blank => false},
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
              :id => "addFormTable",
              :cls => "x-table-layout-cell-top",
              :border => false, :flex => 1, :plain => true,
              :items => [
                  {:name => :repair_type__name, :colspan => 2},
                  {:name => :recordId, :xtype => :hiddenfield, :colspan => 2},
                  {:name => :number, :xtype => :hiddenfield},
                  {:name => :ticket, :xtype => :hiddenfield},
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
                      :grow => true,
                      :colspan => 2,
                      :items => [{
                          :layout => :hbox, :border => false, :defaults => {:border => false},
                          :items => [
                              {# 1st column
                               :flex => 1, :defaults => {:anchor => '-8'},
                               :items => [
                                   {:field_label => Order.human_attribute_name("applied_at"), :name => :applied_at, :xtype => :datefield, :value => Date.today},
                                   {:field_label => Order.human_attribute_name("plan_deliver_at"), :name => :plan_deliver_at, :xtype => :datefield}, #TODO: add default delivery period
                                   {:field_label => Order.human_attribute_name("complect"), :name => :complect__name, :xtype => :textarea},
                                   {:field_label => Order.human_attribute_name("external_state"), :name => :external_state__name, :min_grow => 210, :xtype => :textarea}
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
                      }]
                  }
              ]
          }
      ]
    end
  end

  js_mixin :add_order_form

  def normalize_field_with_suggest(field)
    field = normalize_field_without_suggest(field)
    field[:parent_id] = self.global_id if [:autosuggest, :netzkeboxselect].include?(field[:xtype])

    field
  end

  alias_method_chain :normalize_field, :suggest

  def netzke_submit(params)
    data = ActiveSupport::JSON.decode(params[:data])
    passport = find_or_create(ProductPassport, get_search_options(data, "product_passport"), :factory_number)
    customer = find_or_create(Customer, get_search_options(data, "customer"), :name)
    if passport
      data.reject!{|k,v| k.to_s.match /^product_passport/}
      data[:product_passport_id] = passport.id
    end
    if customer
      data.reject!{|k,v| k.to_s.match /^customer/}
      data[:customer_id] = customer.id
    end
    logger.debug "Current user #{Netzke::Core.current_user.inspect}"
    data[:manager_id] = Netzke::Core.current_user.id
    logger.debug "Data: #{data.inspect}"
    params[:data] = ActiveSupport::JSON.encode data
    begin
      success = create_or_update_record data
      if success
        {:set_result => true, :set_form_values => {:record_id => record.id, :number => record.number,
                                                  :ticket => record.ticket, :_meta => meta_field}}
      end
      #super params
    rescue => e
      logger.error e
      e.backtrace.each{|line| logger.error line}
    end
  end

  protected
  
  def find_or_create(model_class, search_options, id_name)
    record = nil
    return record if search_options.empty?
    if model_class.exists?(search_options)
      #model is already exists, found by matching fields
      logger.debug "#{model_class.name} found by options #{search_options.inspect}"
      record = model_class.find(search_options)
    elsif is_digit?(search_options[id_name]) and model_class.exists?(:id => search_options[id_name])
      #model is already exists, found by id
      logger.debug "#{model_class.name} found by id with #{search_options.inspect}"
      record = model_class.find(search_options[id_name])
    else
      #Create a new model
      logger.debug "Creating new #{model_class.name}"
      record = model_class.create(search_options)
    end
    record
  end

  def is_digit?(str)
    if str
      str.to_s.match(/^\d+$/)
    else
      false
    end
  end
  
  def get_search_options(data, prefix)
    search_options = {}
    data.select{|key, value| key.match /^#{prefix}/}.each{|k,v|
      path = k.split('__')
      if path.size == 2
        key = path[1]
        value = v.to_s
      elsif path.size > 2
        key = "#{path[path.size - 2]}_id"
        data_class = Kernel.const_get(path[path.size - 2].camelize)
        record = create_dict_if_needed(data_class, {:name => v})
        value = record.id # ensure that it`s integer
      end
      search_options.merge!({key.to_sym => value}) if key
    }
    search_options
  end
  
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

  private
  def create_dict_if_needed(klass, params)
    dict = nil
    dict = klass.find(params[:name]) if is_digit?(params[:name]) and klass.exists?(params[:name])
    dict = klass.where(:name => params[:name]) unless dict
    dict = klass.create(params) unless dict
    dict
  end

end