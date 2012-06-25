class DashboardController < ApplicationController
  respond_to :json
  def orders_by_type
    @orders = Order.select("repair_type_id, count(id) as order_count").group(:repair_type_id).
        where("applied_at > ?", 1.month.ago)
    logger.debug @orders.length
    respond_with collect_orders_with_types
    #respond_with :success => true, :total => @orders.length, :orders => collect_orders_with_types
    #render :text => "{success:true,orders:[{id:1,count:11,repair_type:\"\u041f\u043b\u0430\u0442\u043d\u044b\u0439\"},{id:2,count:2,repair_type:\"\u0413\u0430\u0440\u0430\u043d\u0442\u0438\u0439\u043d\u044b\u0439\"}]}"
  end

  def orders_by_status
    @orders = Order.select("status_id, count(id) as order_count").group(:status_id).
        where("applied_at > ? and status_id is not null", 1.month.ago)
    respond_with collect_order_with_statuses
  end

  def top_repaired_products
    @products = Product.joins(:orders).select("products.id, count(orders.*) as order_count").
        group('products.id').where("orders.applied_at > ?", 1.year.ago).order("count(orders.*) DESC").limit(10)
    #others = Product.joins(:orders).where("orders.applied_at > ? and products.id not in (?)", 1.year.ago, @products.map(&:id)).count(:orders)
    respond_with collect_products #<< {:name => 'others', :order_count => others}
  end

  private
  def collect_orders_with_types
    @orders.collect{|o| { :repair_type => RepairType.find(o.repair_type_id).name, :order_count => o.order_count.to_i } }
  end

  def collect_order_with_statuses
    @orders.collect{|o| { :status => Status.find(o.status_id).name, :order_count => o.order_count.to_i }}
  end

  def collect_products
    @products.collect{|p|
      product = Product.find(p.id)
      { :name => product.name, :producer => product.producer ? product.producer.name : '', :order_count => p.order_count }
    }
  end

end
