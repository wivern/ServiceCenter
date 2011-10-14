#encoding: UTF-8
class OrdersPanel < Netzke::Basepack::BorderLayoutPanel

  js_property :preventHeader, true

  def configuration
    super.merge(
        :persistance => true,
        :items => [
            :orders.component(
                :region => :center,
                :title => I18n.t('views.orders.title')
            ),
            :order_details_panel.component(
                :region => :south,
                :title => I18n.t('views.order_details.title'),
                :height => 350,
                :split => true
            )
        ]
    )
  end

  js_method :init_component, <<-JS
    function(){
      this.callParent();
      var view = this.getComponent('orders').getView();
      var self = this;
      view.on('itemclick', function(view, record){
        var orderId = record.get('id');
        self.selectOrder({order_id: orderId, number: record.get('number')});
        var form = self.getComponent('order_details_panel');
        form.netzkeLoad({id: orderId});
      });
    }
  JS

  endpoint :select_order do |params|
    component_session[:selected_order_id] = params[:order_id]
    {
        :order_details_panel => {:set_title => "#{Order.model_name.human} № #{params[:number]}"}
    }
  end

  component :orders do
    {
        :class_name => "OrdersGrid",
        :model => "Order",
        :title => Order.model_name.human,
        :persistence => true,
        :bbar => [:add_order.action, '-', :search.action],
        :context_menu => [:add_order.action],
        :columns => [:repair_type__name, :number, :ticket, :applied_at, :plan_deliver_at, :customer__name,
                     :manager__display_name, :actual_deliver_at, :status__name, :service_note]
    }
  end

  component :order_details_panel do
    {
        :class_name => "OrderDetailsPanel",
        :record_id => component_session[:selected_order_id]
    }
  end
end