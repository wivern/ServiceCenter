#encoding: UTF-8
class DashboardPane < Netzke::Basepack::Panel

  component :orders_by_repair_type_chart do
    {
        :class_name => "Charts::Chart",
        :chart_data_url => "/dashboard/orders_by_type",
        :theme => "Base",
        :axes => [
            {
                :type => 'Numeric',
                :position => 'left',
                :fields => ['order_count'],
                :title => 'Кол-во',
                :minimum => 0
            },
            {
                :type => 'Category',
                :position => 'bottom',
                :fields => ['repair_type'],
                :title => 'Тип ремонта'
            }
        ],
        :series => [
            {
                :type => 'column',
                :stacked => true,
                :axis => 'left',
                :yField => 'order_count',
                :xField => 'repair_type',
                :highlight => true,
                :label => {
                    :display => 'insideEnd',
                    :field => 'order_count',
                    #:orientation => 'vertical',
                    :color => '#333',
                    'text-anchor' => 'middle'
                },
                :tips => {
                    :track_mouse => true,
                    :width => 125,
                    :height => 50,
                    :renderer => <<-JS.l
                      function(store, item){
                      this.setTitle(store.data.repair_type + ' : ' + store.data.order_count)
                    }
                    JS
                }
            }
        ]
    }
  end

  component :orders_by_status_chart do
    {
        :class_name => "Charts::Chart",
        :chart_data_url => "/dashboard/orders_by_status",
        :theme => "Blue",
        :fields => [
            {:name => 'status', :type => 'string'},
            {:name => 'order_count', :type => 'int'}
        ],
        :axes => [
            {
                :type => 'Numeric',
                :position => 'left',
                :fields => ['order_count'],
                :title => 'Кол-во',
                :minimum => 0,
                :decimal => 0
            },
            {
                :type => 'Category',
                :position => 'bottom',
                :fields => ['status'],
                :title => 'Статус'
            }
        ],
        :series => [
            {
                :type => 'column',
                :stacked => true,
                :axis => 'left',
                :yField => 'order_count',
                :xField => 'status',
                :highlight => true,
                :label => {
                    :display => 'insideEnd',
                    :field => 'order_count',
                    #:orientation => 'vertical',
                    :color => '#fff',
                    :contrast => true,
                    'text-anchor' => 'middle'
                },
                :tips => {
                    :track_mouse => true,
                    :width => 125,
                    :height => 50,
                    :renderer => <<-JS.l
                      function(store, item){
                        this.setTitle(store.data.status + ' : ' + store.data.order_count)
                      }
                    JS
                }
            }
        ]
    }
  end

  component :top_repaired_products do
    {
        :class_name => "Charts::Chart",
        :chart_data_url => "/dashboard/top_repaired_products",
        #:theme => "Base",
        #:data_field => 'order_count',
        :fields => [
            {:name => 'name', :type => 'string'},
            {:name => 'order_count', :type => 'int'},
            {:name => 'producer', :type => 'string'}
        ],
        :inset_padding => 25,
        :series => [
            {
                :type => 'pie',
                :field => 'order_count',
                :color_set => ["#94ae0a", "#115fa6","#a61120", "#ff8809", "#ffd13e", "#a61187", "#24ad9a", "#7c7474", "#a66111", "#20C136"],
                :highlight => {
                   :segment => {
                     :margin => 20
                   }
                 },
                :label => {
                    :display => 'rotate',
                    :field => 'name',
                    :color => '#fff',
                    :contrast => true
                },
                :tips => {
                    :track_mouse => true,
                    :width => 125,
                    :height => 60,
                    :renderer => <<-JS.l
                      function(storeItem, item){
                        //console.debug('pie tip', storeItem, item);
                        var store = storeItem.store, total = 0, orders = storeItem.data.order_count;
                        store.each(function(rec){
                          total += rec.get('order_count');
                        });
                        var producer = typeof(storeItem.data.producer) === 'undefined' ? "" : storeItem.data.producer;
                        this.setTitle( producer + ' ' + storeItem.data.name +
                          ",<br>обращений: " + orders + ' (' + Math.round(orders / total * 100) + '%)');
                      }
                    JS
                }
            }
        ]
    }
  end

  def configuration
    super.tap do |s|
      s[:items] = [
          {
              :layout => {:type => 'table', :columns => 2},
              :border => false, :plain => true, :width => '100%',
              :items => [
                  :orders_by_repair_type_chart.component(:width => 450, :height => 300),
                  :orders_by_status_chart.component(:width => 450, :height => 300),
                  {
                      :border => false, :header => false, :layout => {:type => 'vbox', :align => :stretch},
                      :width => 450, :height => 350,
                    :items => [
                      :top_repaired_products.component(:width => 450, :height => 300),
                      {:xtype => 'label', :text => 'Наиболее ремонтируемые', :style => {
                          :font => 'bold 16px Arial',
                          :textAlign => 'center'}
                      }
                    ]
                  }
              ]
          }
      ]
    end
  end

end