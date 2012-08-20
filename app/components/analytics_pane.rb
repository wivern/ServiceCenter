#encoding: UTF-8
class AnalyticsPane < Netzke::Basepack::BorderLayoutPanel

  component :analysis_form do
    {
        :class_name => 'AnalyserForm',
        :region => :east,
        :width => 300,
        :collapsible => true,
        :collapsed => false
    }
  end

  component :analysis_grid do
    {
        :class_name => 'AnalyserGrid',
        :model => 'Order',
        :columns => [
            :ticket, :applied_at, :product_passport__product__name,
            :product_passport__factory_number, :product_passport__producer__name,
            :repair_type__name, :status__name,
            :manager__name,
            :engineer__name, :activities_amount, :activities_count, :spare_parts_amount,
            :total_amount, :total_amount_with_discount, :diag_price, :work_performed_at,
            :actual_deliver_at, :customer__name,
            :order_location__name,
            :spare_parts_printable,
            :reason, :activities_printable
        ],
        :title => "Заказы",
        :prohibit_create => true,
        :prohibit_update => true,
        :prohibit_delete => true,
        :load_inline_data => false,
        :scope => lambda{|rel|
          data = session[:analysis_data]
          data = data.symbolize_keys
          data.reject!{|k,v| v == -1}
          logger.debug("Analysis: #{data.inspect}")
          rel = rel.where("organization_id = ?",data[:organization]) if data[:organization] && data[:organization] != -1
          rel = rel.where("applied_at >= ?", data[:starting_date]) if data[:starting_date]
          rel = rel.where("applied_at <= ?", data[:finish_date]) if data[:finish_date]
          rel = rel.where("repair_type_id = ?", data[:repair_type]) if data[:repair_type] && data[:repair_type] != -1
          rel = rel.where("status_id = ?", data[:status]) if data[:status]
          rel = rel.where("producer_id = ?", data[:producer]) if data[:producer]
          rel = rel.where("manager_id = ?", data[:manager]) if data[:manager]
          rel = rel.where("engineer_id = ?", data[:engineer]) if data[:engineer]
          rel = rel.where("location_id = ?", data[:order_location]) if data[:order_location]
          rel.order(:ticket)
        }
    }
  end

  def configuration
    super.tap do |sup|
      sup[:items] = [
          :analysis_grid.component(:region => :center, :prevent_header => false),
          :analysis_form.component
      ]
    end
  end

  js_include :export

  js_method :init_component, <<-JS
    function(){
      this.callParent(arguments);
      var form = this.getChildNetzkeComponent('analysis_form');
      if (form) form.on('submitsuccess', function(){
        this.getChildNetzkeComponent('analysis_grid').store.load();
      }, this);
    }
  JS

  end