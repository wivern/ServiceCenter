#encoding: UTF-8

class OrdersGrid < Netzke::Basepack::GridPanel

  include ServiceCenter::Reportable

  action :add_order do
    {
        :text => I18n.t('views.actions.add_order.text'),
        :tooltip => I18n.t('views.actions.add_order.tooltip'),
        :icon => :table_add
    }
  end

  action :print do
    {
        :text => I18n.t('views.actions.print.text'),
        :tooltip => I18n.t('views.actions.print.tooltip'),
        :icon => :printer,
        :disabled => true
    }
  end

  action :open do
    {
        :text => I18n.t('views.actions.open.text'),
        :tooltip => I18n.t('views.actions.open.tooltip'),
        :icon => :page_go,
        :disabled => true
    }
  end

  def configuration
    @ability = Ability.new Netzke::Core.current_user
    super
  end

  def default_bbar
    bbar = []
    bbar << { :text => 'Создать из', :name => 'createFrom', :icon => :link_add.icon, :menu => create_from_menu, :disabled => true} << "-" if @ability.can? :create, Order
    bbar << :search.action << "-" << :open.action
    bbar << {:text => 'Печать', :icon => :printer.icon, :name => 'print', :menu => [], :disabled => true}
    bbar << "-" <<  :edit.action << :apply.action if @ability.can?(:update, Order)
    bbar << :del.action if @ability.can?(:delete, Order)
    bbar
  end

  def default_context_menu
    [:open.action, {:text => 'Печать', :icon => '/images/icons/printer.png', :name => 'print', :menu => []}] # *super
  end

  component :add_order_form do
    {
        :lazy_loading => true,
        :class_name => "WideFormWindow",
        :title => "#{I18n.t('views.actions.add_order.text')}",
        :width => 640,
        :button_align => "right",
        :defaults => {:editable => false},
        :items => [{
                       :class_name => "AddOrderForm",
                       :model => config[:model],
                       :items => default_fields_for_forms,
                       :persistent_config => config[:persistent_config],
                       :strong_default_attrs => config[:strong_default_attrs],
                       :border => true,
                       :bbar => false,
                       :prevent_header => true,
                       :mode => config[:mode],
                       :record => data_class.new(columns_default_values)
                   }.deep_merge(config[:add_form_config] || {})]
    }
    .deep_merge(config[:add_form_window_config] || {})
  end

  js_method :on_add_order, <<-JS
    function(){
        this.loadNetzkeComponent({name: "add_order_form", callback: function(w){
          w.show();
          w.on('close', function(){
              if (w.closeRes === "ok") {
                this.store.load();
              }
          }, this);
      }, scope: this});
    }
  JS

  js_mixin :orders_grid

  js_include "#{File.dirname(__FILE__)}/javascripts/print.js"

  js_method :on_print, <<-JS
    function (){
      var selection = this.getSelectionModel().getLastSelected();
      var orderId = selection.get('id');
      //console.debug("Selected: " + selection.get('id'));
      printForm.dom.action = "/print/ticket/"+orderId;
      printForm.dom.submit();
    }
  JS

  endpoint :create_from do |params|
    if @ability.can? :create, Order
      order = Order.find(params[:order_id])
      repair_type = RepairType.find(params[:repair_type_id])
      new_order = order.clone :include => [:complects, :external_states, :defects, :grounds, :internal_states]
      #new_order.complect_ids = order.complect_ids
      order.order_activities.each{|oa|
        new_order.order_activities << oa.clone
      }
      order.order_spare_parts.each{|os|
        new_order.order_spare_parts << os.clone
      }
      new_order.repair_type = repair_type
      new_order.created_from = order
      logger.debug "Cloned order #{new_order.inspect}"
      if new_order.save
        return {:set_result => 'ok', :netzke_feedback => @flash, :open_order => [new_order.id, new_order.number]}
      else
        logger.error "Order clone errors, #{new_order.errors.inspect}"
        {:netzke_feedback => new_order.errors}
      end
    else
      flash :error => I18n.t('access_denied')
      {:netzke_feedback => @flash}
    end
  end

  private
  def create_from_menu
    RepairType.all.map{|t|
      {:text => t.name, :repair_type => t.id}
    }
  end

end