class OrdersGrid < Netzke::Basepack::GridPanel
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
        :icon => :printer
    }
  end

  def default_bbar
    [:add_order.action, '-', :print.action]
  end

  def default_context_menu
    [:add_order.action, :print.action] # *super
  end

  component :add_order_form do
    {
        :lazy_loading => true,
        :class_name => "WideFormWindow",
        :title => "#{I18n.t('views.actions.add_order.text')}",
        :width => 640,
        :button_align => "right",
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
    #.deep_merge(config[:add_form_window_config] || {})
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

  js_include :print

  js_method :on_print, <<-JS
    function (){
      var selection = this.getSelectionModel().getLastSelected();
      var orderId = selection.get('id');
      //console.debug("Selected: " + selection.get('id'));
      printForm.dom.action = "/print/ticket/"+orderId;
      printForm.dom.submit();
    }
  JS

end