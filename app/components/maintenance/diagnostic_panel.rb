#encoding: UTF-8
module Maintenance
  class DiagnosticPanel < Netzke::Basepack::BorderLayoutPanel
    component :diagnostic_form do
        {
            :class_name => "Maintenance::DiagnosticForm",
            :record_id => component_session[:selected_order_id],
            :title => "Диагностика"
        }
      end

      component :orders do
        {
            :class_name => "OrdersGrid",
            :model => "Order",
            :columns => [ :ticket, :applied_at, :product_passport__factory_number ]
        }
      end

      def configuration
        super.tap do |c|
          c[:items] = [
              :orders.component(:region => :center, :prevent_header => true),
              :diagnostic_form.component(:region => :south, :split => true, :height => 350, :collapsible => true)
          ]
        end
      end

      endpoint :select_order do |params|
        component_session[:selected_order_id] = params[:order_id]
        {
            :diagnostic_form => {:set_title => "Диагностика № #{params[:ticket]}"}
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
            var form = self.getComponent('diagnostic_form');
            form.netzkeLoad({id: orderId});
          });
        }
      JS
  end
end