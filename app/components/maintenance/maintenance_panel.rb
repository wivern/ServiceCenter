#encoding: UTF-8
module Maintenance
  class MaintenancePanel < Netzke::Basepack::BorderLayoutPanel
    component :orders do
      {
          :class_name => "OrdersGrid",
          :model => "Order",
          :columns => [ :ticket, :applied_at, :product_passport__factory_number ]
      }
    end
    component :maintenance do
      {
          :class_name => "Maintenance::MaintenanceForm",
          :record_id => component_session[:selected_order_id],
          :title => "Ремонт"
      }
    end

    def configuration
      super.tap do |c|
        c[:items] = [
            :orders.component(:region => :center, :prevent_header => true),
            :maintenance.component(:region => :south, :height => 350, :split => true, :collapsible => true)
        ]
      end
    end

    endpoint :select_order do |params|
      component_session[:selected_order_id] = params[:order_id]
      {
          :maintenance => {:set_title => "Ремонт № #{params[:ticket]}"}
      }
    end

    js_method :init_component, <<-JS
      function(){
        this.callParent();
        var view = this.getComponent('orders').getView();
        var self = this;
        view.on('itemclick', function(view, record){
          var orderId = record.get('id');
          self.selectOrder({order_id: orderId, ticket: record.get('ticket')});
          var form = self.getComponent('maintenance');
          form.gridsLoad(orderId);
        });
      }
    JS
  end
end