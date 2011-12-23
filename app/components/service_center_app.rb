#encoding: UTF-8
require 'yaml'


class ServiceCenterApp < TabbedApp #Netzke::Basepack::AuthApp

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

  Dir.glob(File.join(File.dirname(__FILE__),"javascripts", "*.js")).sort.each{ |f|
    ::Rails.logger.debug("include #{f}")
    js_include f unless /mixin/ =~ f
  }

  js_include "#{File.dirname(__FILE__)}/dialog_trigger_field/javascripts/dialog_trigger_field.js"

  #Components
  component :orders,
            :class_name => "OrdersGrid",
            :model => "Order",
            :lazy_loading => true,
            :title => Order.model_name.human,
            :persistence => true,
            :prohibit_create => true,
            #:bbar => [:add_order.action, '-', :search.action],
            :columns => [
              {:name => :repair_type__name, :read_only => true},
              {:name => :number, :read_only => true},
              {:name => :ticket, :read_only => true},
              {:name => :applied_at, :read_only => true},
              {:name => :plan_deliver_at},
              {:name => :customer__name, :read_only => true},
              {:name => :manager__display_name, :read_only => true},
              :actual_deliver_at, :status__name, :service_note]

  component :order_form,
        :class_name => "AddOrderForm",
        :model => "Order",
        :title => "Приемка",
        :persistance => false

  component :order_details,
      :class_name => "OrderDetailsPanel",
      :title => "Карточка заказа"

  action :about, :icon => :information

  def menu
    super.tap do |menu|
      menu << :about.action
    end
  end

  endpoint :select_order do |params|
    session[:selected_order_id] = params[:order_id]
  end


  def dictionaries
    d = YAML.load_file(File.expand_path('../dictionaries.yml', __FILE__))
    d['components'].each{ |name, options|
      options[:columns] = options[:columns].map{|k,v| v ? v : k} if options.has_key? :columns
      options[:title] = options[:model].constantize.model_name.human(:count => 2) unless options.has_key? :title
      self.class.component name, options
    }
    proceed_children(d['dictionaries'])
    #d['dictionaries'].map{ |k, v|
    #  v['text'] = I18n.t(v['text'], :default => k.titleize) if v.has_key? 'text'
    #  proceed_children(v['children']) if v.has_key? 'children'
    #  v
    #}
  end

  def proceed_children(items)
    items.map{|k,v|
      v['text'] = I18n.t(v['text'], :default => k.titleize) if v.has_key? 'text'
      v['children'] = proceed_children(v['children']) if v.has_key? 'children'
      v
    }
  end

  js_mixin :service_center_app

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
      //this.addEvents('beforeloadcomponent');
    }
  JS

end