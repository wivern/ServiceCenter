#encoding: UTF-8
class AddOrderForm < Netzke::Basepack::FormPanel

  #js_include "#{File.dirname(__FILE__)}/javascripts/lookup_field.js"

  include ServiceCenter::ExtendedForm

  js_include :validators

  endpoint :select_producer do |params|
    logger.debug "Selected producer #{params[:producer]}"
    component_session[:selected_producer] = params[:producer]
    { :set_result => {:producer => params[:producer]}}
  end


  component :select_diagnostic_activity do
    {
        :class_name => "DictionaryWindow",
        :model => "Activity",
        :scope => "diagnostic = true",
        :initial_sort => ['name', 'ASC']
    }
  end

  component :select_producer do
    {
        :class_name => "DictionaryWindow",
        :model => "Producer",
        :initial_sort => ['name', 'ASC']
    }
  end

  component :select_product do
    {
        :class_name => "DictionaryWindow",
        :model => "Product",
        :columns => [:name],
        :scope => {:producer_id => component_session[:selected_producer]},
        :initial_sort => ['name', 'ASC']
    }
  end

  component :select_purchase_place do
    {
        :class_name => "DictionaryWindow",
        :model => "PurchasePlace",
        :columns => [:name],
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

  component :select_external_state do
    {
        :class_name => "DictionaryWindow",
        :model => "ExternalState",
        :prohibit_modify => true,
        :initial_sort => ['name', 'ASC']
    }
  end

  def default_config
    super.merge(:model => "Order")
  end

  def configuration
    super.tap do |s|
      configure_locked(s)
      configure_bbar(s)
      product_passport_fields = [
          {:name => :product_passport__factory_number, :xtype => :autosuggest, :populate_related_fields => true, :allow_blank => false,
            :allow_new => true},
          {:name => :product_passport__producer__name, :xtype => :selecttriggerfield,
            :selection_component => :select_producer},
          {:name => :product_passport__product__name, :xtype => :selecttriggerfield,
            :selection_component => :select_product},
          {:name => :product_passport__guarantee_stub_number, :xtype => :textfield, :submit_value => true},
          {:name => :product_passport__purchase_place__name, :xtype => :selecttriggerfield,
             :selection_component => :select_purchase_place, :allowNew => true},
          {:name => :product_passport__purchased_at, :xtype => :datefield, :format => "d.m.y"},
          {:name => :product_passport__dealer__name, :xtype => :autosuggest, :allowNew => true}]
      customer_fields = [
          {:name => :customer__name, :xtype => :autosuggest, :populate_related_fields => true, :allow_blank => false, :allow_new => true},
          {:name => :customer__address, :xtype => :textarea},
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
                  {:name => :repair_type__name, :colspan => 2, :editable => false, :allow_blank => false},
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
                      :collapsible => true,
                      :items => [{
                          :layout => :hbox, :border => false, :defaults => {:border => false},
                          :items => [
                              {# 1st column
                               :flex => 1, :defaults => {:anchor => '-8'},
                               :items => [
                                   {:field_label => Order.human_attribute_name("applied_at"), :name => :applied_at,
                                      :format => "d.m.y", :xtype => :datefield, :value => Date.today}, #TODO get date format from locale
                                   {:field_label => Order.human_attribute_name("plan_deliver_at"), :name => :plan_deliver_at,
                                      :xtype => :datefield, :format => "d.m.y", :value => Date.today + 2.weeks}, #TODO: add default delivery period
                                   {:field_label => Order.human_attribute_name("complect"), :name => :complects__name,
                                      :xtype => :netzkeboxselect, :editable => false, :hide_trigger => true, :height => 110},
                                   {:field_label => Order.human_attribute_name("external_state"), :name => :external_states__name,
                                    :xtype => :netzkepopupselect, :selection_component => :select_external_state, :height => 140},
                                   {:name => :external_state_note, :xtype => :textarea, :heigh => 140}
                               ]
                              },
                              {# 2nd column
                               :flex => 1, :defaults => {:anchor => '100%'},
                               :items => [
                                   {:field_label => Order.human_attribute_name("defect"), :name => :defects__name, :xtype => :netzkepopupselect,
                                    :width => 320, :height => 140, :selection_component => :select_defect},
                                   {:field_label => Order.human_attribute_name("diag_price"), :name => :diagnostic_activity__price,
                                    :xtype => :selecttriggerfield, :selection_component => :select_diagnostic_activity,
                                    :display_field => :price}
                                   #{:field_label => Order.human_attribute_name("prior_cost"), :name => :prior_cost,
                                   #   :xtype => :numericfield, :currency_at_end => true, :currency_symbol => 'руб.', :step => 10},
                                   #{:field_label => Order.human_attribute_name('maximum_cost'), :name => :maximum_cost,
                                   #   :xtype => :numericfield, :currency_at_end => true, :currency_symbol => 'руб.', :step => 10}
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

  ##
  # Prevents of autocreation supposed dictionary class
  #
  def self.prevent_of_creation(klass)
    @@prevent_creation_classes ||= []
    @@prevent_creation_classes << klass
  end

  prevent_of_creation Producer
  prevent_of_creation Product

  js_mixin :add_order_form

  #def normalize_field_with_suggest(field)
  #  field = normalize_field_without_suggest(field)
  #  field[:parent_id] = self.global_id if [:autosuggest, :netzkeboxselect, :netzkepopupselect].include?(field[:xtype])
  #
  #  field
  #end
  #
  #alias_method_chain :normalize_field, :suggest

  def netzke_submit(params)
    data = ActiveSupport::JSON.decode(params[:data])
    data["product_passport__purchased_at"] = Date.strptime(data["product_passport__purchased_at"], '%d.%m.%y').to_time_in_current_zone if data["product_passport__purchased_at"]
    passport = find_or_create(ProductPassport, get_search_options(data, "product_passport"),
                              :factory_number)
    customer = find_or_create(Customer, get_search_options(data, "customer"), :name)
    if passport
      data.reject!{|k,v| k.to_s.match /^product_passport/}
      data[:product_passport_id] = passport.quoted_id
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
      success = create_or_update_record(data) and passport.valid? and customer.valid?
      if success
        {:set_result => true, :set_form_values => {:record_id => record.id, :number => record.number,
                                                  :ticket => record.ticket, :_meta => meta_field}}
      else
        logger.debug "Customer: #{customer.inspect}\n Passport: #{passport.inspect}"
        logger.debug "Passport errors: #{passport.errors.inspect}"
        errors = []
        errors += @record.errors.to_a
        errors += passport.errors.to_a if passport
        errors += customer.errors.to_a if customer
        errors.each do |msg|
          flash :error => msg
        end
        {:set_result => false, :netzke_feedback => @flash, :apply_form_errors => build_form_errors(record)}
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
      record = model_class.where(search_options).first
    elsif is_digit?(search_options[id_name]) and model_class.exists?(:id => search_options[id_name])
      #model is already exists, found by id
      logger.debug "#{model_class.name} found by id with #{search_options.inspect}"
      record = model_class.find(search_options[id_name])
    else
      #Create a new model
      record = model_class.create(search_options)
      logger.debug "New #{model_class.name} created #{record.inspect}"
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
      value = nil
      if path.size == 2
        key = path[1]
        value = v.to_s
      elsif path.size > 2
        key = "#{path[path.size - 2]}_id"
        data_class = Kernel.const_get(path[path.size - 2].camelize)
        record = find_dictionary_value(data_class, {:name => v})
        logger.debug "Searching #{data_class.name} with #{v} #{record ? "found" : ""}"
        value = record.id if record # ensure that it`s integer
      end
      search_options.merge!({key.to_sym => value}) if key and value
    }
    search_options
  end
  
  def all_association_syms(assoc)
    assoc.klass.reflect_on_all_associations.map{|k| k.name.to_sym}
  end

  private
  ## Finds dictionary of given model Klass by
  ## specified params, which either may be key of value
  ## or hash of model`s field-value :name => :something
  ## returns nil if found nothing
  def find_dictionary_value(klass, params)
    logger.debug "Find or create #{klass.name} with #{params.inspect}"
    dict = nil
    dict = klass.find(params[:name]) if is_digit?(params[:name]) and klass.exists?(params[:name])
    dict = klass.where(:name => params[:name]) unless dict
    #dict = klass.create(params) unless dict and not @@prevent_creation_classes.include? klass
    dict
  end

end