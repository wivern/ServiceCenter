#encoding: UTF-8
require 'yaml'


class ServiceCenterApp < TabbedApp #Netzke::Basepack::AuthApp

  def configuration
    @ability = Ability.new Netzke::Core.current_user
    sup = super
    sup.merge(
        :current_user => Netzke::Core.current_user.id,
        :items => [
            #{
            #           :region => :north,
            #           :border => false,
            #           :height => 35,
            #           :html => %Q{
            #<div style="margin:10px; color:#333; text-align:center; font-family: Helvetica; font-size: 150%;">
            #  <a style="color:#B32D15; text-decoration: none" href="/">Сервис-центр</a>
            #</div>
            #},
            #           :bodyStyle => {:background => %Q(#FFF url("/images/header-deco.gif") top left repeat-x)},
            #       },
        {
            :region => :center,
            :layout => :border,
            :border => false,
            :items => [status_bar_config, {
                :region => :center,
                :layout => :border,
                :items => [menu_bar_config, main_panel_config, {
                    #Navigation
                    :region => :west,
                    :collapsible => true,
                    :width => 250,
                    :split => true,
                    :xtype => :treepanel,
                    :title => I18n.t('views.navigation.title'),
                    :root_visible => false,
                    :item_id => :navigation,
                    :root => {
                        :text => 'Navigation',
                        :expanded => true,
                        :children => root_items
                    },
                }]
            }]
        }]
    )
  end

  def main_panel_config(overrides = {})
    {
            :item_id => 'main_panel',
            :xtype => 'tabpanel',
            :region => 'center',
            :deferredRender => false,
            :autoScroll => true,
            :margins => '0 4 4 0',
            :activeTab => 0,
            :items => [ :dashboard.component(:title => "Панель управления")]
        }.merge(overrides)
  end

  Dir.glob(File.join(File.dirname(__FILE__), "javascripts", "*.js")).sort.each { |f|
    ::Rails.logger.debug("include #{f}")
    js_include f unless /mixin/ =~ f
  }

  js_include "#{File.dirname(__FILE__)}/dialog_trigger_field/javascripts/dialog_trigger_field.js"

  #Components
  component :dashboard do
    {
        :class_name => "DashboardPane"
    }
  end

  component :reset_password_form do
    form_config = {
        :class_name => "Netzke::Basepack::FormPanel",
        :model => "Person",
        :prevent_header => true,
        :bbar => false,
        :items => [
            {:name => :name},
            {:name => :email, :xtype => :hiddenfield},
            {:name => :username, :xtype => :hiddenfield},
            {:name => :organization__name, :xtype => :hiddenfield},
            {:name => :password, :input_type => :password},
            {:name => :password_confirmation, :input_type => :password}
        ],
        :title => I18n.t('views.actions.reset_password.text')
    }

    {
      :lazy_loading => false,
      :class_name => "Netzke::Basepack::GridPanel::RecordFormWindow",
      :title => I18n.t('views.actions.reset_password.text'),
      :button_align => "right",
      :items => [form_config]
    }.deep_merge(config[:edit_form_window_config] || {})
  end

  component :orders,
            :class_name => "OrdersGrid",
            :model => "Order",
            :lazy_loading => true,
            :title => Order.model_name.human,
            :persistence => true,
            :prohibit_create => true,
            :scope => :by_organization,
            :force_fit => false,
            #:bbar => [:add_order.action, '-', :search.action],
            :columns => [
                {:name => :repair_type__name, :read_only => true, :filter => {:type => :list}, :width => 86},
                {:name => :number, :read_only => true, :hidden => true},
                {:name => :product__name, :read_only => true, :filter => {:type => :string},
                  :filterable => true, :sorting_scope => :order_by_product, :width => 148},
                {:name => :ticket, :read_only => true, :width => 72},
                {:name => :applied_at, :read_only => true, :width => 86},
                {:name => :product_passport__factory_number, :read_only => true, :width => 72},
                {:name => :plan_deliver_at, :width => 72, :flex => 0},
                {:name => :customer__name, :read_only => true, :width => 128, :flex => 0},
                {:name => :manager__display_name, :read_only => true, :filterable => true,
                  :filter => {:type => :list, :value_model => 'Person', :data_index => 'manager__display_name',
                              :scope => :active_and_in_current_organization}, :width => 96},
                {:name => :order_location__name, :filter => {:type => :list}},
                :actual_deliver_at,
                {:name => :status__name, :filter => {:type => :list}},
                :service_note]

  component :maintenance,
        :class_name => "EngineerWorkAreaPanel",
        :title => "Ремонт и диагностика",
        :icon_cls => "maintenance"

  component :order_form,
            :class_name => "AddOrderForm",
            :model => "Order",
            :title => "Приемка",
            :persistance => false,
            :icon_cls => "ordering"

  component :order_details,
            :class_name => "OrderDetailsPanel",
            :title => "Карточка заказа"

  component :analytics,
            :class_name => "AnalyticsPane",
            :title => "Аналитика",
            :icon_cls => "analysis"

  component :jobs,
        :class_name => "JobsGrid",
        :model => "ExchangeJob",
        :title => "Задания",
        :force_fit => true,
        :icon_cls => "task",
        :columns => [
            {:name => :type, :renderer => :render_type_icon},
            :name, :target_path, :value, :run_at, :running?,
            {:name => :latest_run, :read_only => true, :renderer => :render_date_time},
            {:name => :success, :read_only => true},
            {:name => :message, :read_only => true},
        ]

  action :about, :icon => :information
  action :home, :icon => :house

  js_method :on_home, <<-JS
    function (){
      //document.location = '/';
      this.addTab('DashboardPane', {});
    }
  JS

  def menu
    super.tap do |menu|
      user = Netzke::Core.current_user
      if user
        menu << {
            :text => user.organization.name
        }
      end
      menu << :about.action
    end
  end

  endpoint :select_order do |params|
    session[:selected_order_id] = params[:order_id]
  end

  def deliver_component_endpoint(params)
    components[:reset_password_form][:items].first.merge!(:record_id => params[:record_id].to_i) if params[:name] == 'reset_password_form'
    component_name = params[:name].underscore.to_sym
    logger.debug "Checking access to #{component_name}"
    if not (component_name.to_s =~ /^tab*$/) or @ability.can?(:deliver, component_name)
      super
    else
      {:component_delivery_failed => {:component_name => component_name, :msg => "Access denied to component '#{component_name}'"}}
    end
  end

  def dictionaries
    d = YAML.load_file(File.expand_path('../dictionaries.yml', __FILE__))
    d['components'].each { |name, options|
      options[:columns] = options[:columns].map { |k, v| v ? v : k } if options.has_key? :columns
      options[:title] = options[:model].constantize.model_name.human unless options.has_key? :title
      logger.debug "Registering component #{name}"
      self.class.component name, options
    }
    components = d['components'].symbolize_keys
    proceed_children(d['dictionaries'], components)
  end

  def proceed_children(items, components = {})
    logger.debug "Components #{components.inspect}"

    items.select{|k, v|
      if (v['leaf'])
        cmp = components[v['component'].to_sym]
        logger.debug "Checking #{cmp.inspect} for #{v}"
        r = @ability.can?(:read, cmp[:model].constantize) if cmp && cmp.has_key?(:model)
        r ||= false
        logger.debug r ? "accepted" : "rejected"
        r
      else
        true
      end
    }.map { |k, v|
      v['text'] = I18n.t(v['text'], :default => k.titleize) if v.has_key? 'text'
      v['children'] = proceed_children(v['children'], components) if v.has_key? 'children'
      v
    }.select{ |v|
      v['leaf'] or (v.has_key?('children') and not v['children'].empty?)
    }
  end

  js_mixin :service_center_app

  js_method :on_about, <<-JS
    function(e){
    var msg = [
    'Лицензия: GPLv3',
    'Исходные коды программы: <a href="https://github.com/wivern/ServiceCenter">GitHub</a>.',
    '','',
    'Разработка: <a href="mailto:vitaly.koulakov@gmail.com">Кулаков Виталий</a>', '',''
    ].join("<br/>");

    Ext.Msg.show({
      width: 300,
      title: 'О программе',
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

  js_method :on_reset_password, <<-JS
    function(){
        var recordId = this.currentUser;
        this.loadNetzkeComponent({
           name: 'reset_password_form',
           params: {record_id: recordId},
           callback: function(w){
               w.show();
               w.on('close', function(){
                  if (w.closeRes === "ok"){
                      //some message
                      Ext.MessageBox.show({
                          title: "Смена пароля",
                          msg: "Пароль успешно изменен!",
                          buttons: Ext.MessageBox.OK,
                          icon: Ext.MessageBox.INFO
                      });
                  }
               }, this);
           },
           scope: this });
    }
  JS

  protected

  def root_items
    items = []
    items << {
        :text => "Приемка",
        :leaf => true,
        :component => :order_form,
        :icon_cls => 'ordering'
    } if @ability.can?(:deliver, :order_form)
    items << {
        :text => "Заказы",
        :leaf => true,
        :component => :orders
    } if @ability.can?(:read, Order)
    items << {
        :text => "Ремонт и диагностика",
        :leaf => true,
        :icon_cls => 'maintenance',
        :component => :maintenance
    } # if Netzke::Core.current_user.has_role_engineer?
    items << {
        :text => "Аналитика",
        :leaf => true,
        :component => :analytics,
        :icon_cls => 'analysis'
    } if Netzke::Core.current_user.has_role_analyst?
    items << {
        :text => "Обмен данными",
        :expanded => true,
        :icon_cls => "exchange",
        :children => [
            {
                :text => "Задания",
                :leaf => true,
                :icon_cls => 'task',
                :component => :jobs
            },
            {
                :text => "Монитор",
                :leaf => true,
                :icon_cls => 'monitor'
            }
        ]
    } if Netzke::Core.current_user.has_role_administrator?
    dict_items = dictionaries
    items << {
            :text => "Справочники",
            :expanded => true,
            :children => dict_items,
            :icon_cls => 'dictionaries'
    } unless dict_items.empty?
    items
  end

end