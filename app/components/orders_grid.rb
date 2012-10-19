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

  action :filter_by_serial_num do
    {
        :icon => :camera
    }
  end

  js_translate :filters_menu_text


  def configuration

    @user = Netzke::Core.current_user
    @ability = Ability.new @user
    super
  end

  def js_config
    res = super
    res.merge({
        :tbar => config.has_key?(:tbar) ? config[:tbar] : default_tbar
    })
  end

  def default_tbar
    tbar = []
    tbar << :filter_by_serial_num.action
  end

  def default_bbar
    bbar = []
    bbar << { :text => 'Создать из', :name => 'createFrom', :icon => :link_add.icon, :menu => create_from_menu, :disabled => true} << "-" if @ability.can? :create, Order
    bbar << :search.action << "-" << :open.action
    bbar << {:text => 'Печать', :icon => :printer.icon, :name => 'print', :menu => [], :disabled => true} if @user.has_no_role_engineer?
    bbar << "-" <<  :edit.action << :apply.action if @ability.can?(:update, Order)
    bbar << :del.action if @ability.can?(:delete, Order)
    bbar
  end

  def default_context_menu
    menu = [:open.action]
    menu << {:text => 'Печать', :icon => '/images/icons/printer.png', :name => 'print', :menu => []} if @user.has_no_role_engineer?
    menu
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

  #js_include "#{File.dirname(__FILE__)}/javascripts/print.js"

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
      order.external_states.each{|es|
        logger.debug "Cloning state #{es.inspect}"
        new_order.external_states << es.clone
      }
      new_order.repair_type = repair_type
      new_order.created_from = order
      logger.debug "Cloned order #{new_order.inspect}"
      if new_order.save
        notice = I18n.t('orders_grid.notice.order_created', :ticket => new_order.ticket)
        return {:set_result => 'ok', :netzke_feedback => notice, :open_order => [new_order.id, new_order.ticket]}
      else
        logger.error "Order clone errors, #{new_order.errors.inspect}"
        {:netzke_feedback => new_order.errors.to_s}
      end
    else
      flash :error => I18n.t('access_denied')
      {:netzke_feedback => @flash}
    end
  end


  endpoint :get_list_filter_data do |params|
    get_list_filter_data(params)
  end
  protected
  def get_list_filter_data(params = {})
    logger.debug "list filter params: #{params.inspect}"
    model = params['model'].camelize.constantize
    @items = model.scoped
    #params[:scope].split('.').each{|scope| @items = @items.send(scope)} if params[:scope]
    @items = @items.send(params[:scope]) if params[:scope]
    @items = @items.order(:name)
    @items.map{|c| {:id => c.id, :name => c.name} }
  end

  private
  def create_from_menu
    RepairType.all.map{|t|
      {:text => t.name, :repair_type => t.id}
    }
  end

end