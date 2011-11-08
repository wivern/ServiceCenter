#encoding: UTF-8
require 'yaml'


class ServiceCenterApp < Netzke::Basepack::AuthApp

  def configuration
    sup = super
    sup.merge(
        :items => [{
                       :region => :north,
                       :border => false,
                       :height => 35,
                       :html => %Q{
            <div style="margin:10px; color:#333; text-align:center; font-family: Helvetica; font-size: 150%;">
              <a style="color:#B32D15; text-decoration: none" href="/">Сервис-центр</a>
            </div>
            },
                       :bodyStyle => {:background => %Q(#FFF url("/images/header-deco.gif") top left repeat-x)},
                   }, {
            :region => :center,
            :layout => :border,
            :border => false,
            :items => [status_bar_config, {
                :region => :center,
                :layout => :border,
                :items => [menu_bar_config, main_panel_config, {
                    #Navigation
                    :region => :west,
                    :width => 250,
                    :split => true,
                    :xtype => :treepanel,
                    :title => I18n.t('views.navigation.title'),
                    :root_visible => false,
                    :item_id => :navigation,
                    :root => {
                        :text => 'Navigation',
                        :expanded => true,
                        :children => [{
                                          :text => "Приемка",
                                          :leaf => true,
                                          :component => :order_form,
                                          :icon => uri_to_icon(:application_form_add)
                                      },
                                      {
                                          :text => "Заказы",
                                          :leaf => true,
                                          :component => :orders
                                      },
                                      {
                                          :text => "Заказы с формой",
                                          :leaf => true,
                                          :component => :orders_panel
                                      },
                                      {
                                          :text => "Справочники",
                                          :expanded => true,
                                          :children => dictionaries
                            }]
                    }
                }]
            }]
        }]
    )
  end

  #Components
  component :orders,
            :class_name => "OrdersGrid",
            :model => "Order",
            :lazy_loading => true,
            :title => Order.model_name.human,
            :persistence => true,
            #:bbar => [:add_order.action, '-', :search.action],
            :columns => [:repair_type__name, :number, :ticket, :applied_at, :plan_deliver_at, :customer__name,
              :manager__display_name, :actual_deliver_at, :status__name, :service_note]

  component :orders_panel,
      :lazy_loading => true

  component :order_form,
        :class_name => "AddOrderForm",
        :model => "Order",
        :title => "Приемка",
        :persistance => false

  action :about, :icon => :information

  def menu
    super.tap do |menu|
      menu << :about.action
    end
  end

  def dictionaries
    d = YAML.load_file(File.expand_path('../dictionaries.yml', __FILE__))
    puts d.inspect
    d['components'].each{ |name, options|
      options[:columns] = options[:columns].map{|k,v| v ? v : k} if options.has_key? :columns
      options[:title] = options[:model].constantize.model_name.human unless options.has_key? :title
      ServiceCenterApp::component name, options
    }
    d['dictionaries'].map{ |k, v|
      v['text'] = I18n.t(v['text'], :default => k.titleize) if v.has_key? 'text'
      v
    }
  end

  js_method :on_about, <<-JS
    function(e){
    var msg = [
    '',
    'Source code for this demo: <a href="https://github.com/skozlov/netzke-demo">GitHub</a>.',
    '', '',
    '<div style="text-align:right;">Why follow <a href="http://twitter.com/nomadcoder">NomadCoder</a>?</div>'
    ].join("<br/>");

    Ext.Msg.show({
    width: 300,
    title:'About',
    msg: msg,
    buttons: Ext.Msg.OK,
    animEl: e.getId()
    });
    }
  JS

  # Overrides Ext.Component#initComponent to set the click event on the nodes
  js_method :init_component, <<-JS
    function(){
      this.callParent();
      this.navigation = this.query('panel[itemId="navigation"]')[0];
      this.navigation.getView().on('itemclick', function(e,r,i){
      if (r.raw.component) {
        this.appLoadComponent(r.raw.component);
      }
      }, this);
    }
  JS
  # Overrides SimpleApp#process_history, to initially select the node in the navigation tree
  js_method :process_history, <<-JS
    function(token){
      if (token) {
        var node = this.navigation.getStore().getRootNode().findChildBy(function(n){
          return n.raw.component == token;
        }, this, true);

        if (node) this.navigation.getView().select(node);
      }

      this.callParent([token]);
    }
  JS

end