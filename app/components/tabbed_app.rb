class TabbedApp < Netzke::Basepack::AuthApp
  def main_panel_config(overrides={})
    {
        :item_id => 'main_panel',
        :xtype => 'tabpanel',
        :region => 'center',
        :deferredRender => false,
        :autoScroll => true,
        :margins => '0 4 4 0',
        :activeTab => 0
    }.merge(overrides)
  end

  action :reset_password do
    {
        :tooltip => I18n.t('views.actions.reset_password.tooltip'),
        :icon => :lock_edit
    }
  end

  js_mixin :tabbed_app

  def components
    stored_components.inject(super){ |r, comp| r.merge(comp[:name].to_sym => comp.reverse_merge(:prevent_header => true, :lazy_loading => true, :border => false)) }
  end

  def deliver_component_endpoint(params)
    logger.debug "Deliver component #{params.inspect}"
    cmp_name = params[:name]
    if params[:component].present?
      logger.debug "Component #{params[:component]}"
      cmp_class = constantize_class_name(params[:component])
      raise RuntimeError, "Could not find class #{params[:component]}" if cmp_class.nil?
      cmp_config = {:name => cmp_name, :class_name => cmp_class.name, :persistance => true}.merge(params[:config] || {}).symbolize_keys
      cmp_instance = cmp_class.new(cmp_config, self)
      #self.class.component(cmp_name.to_sym, cmp_config)
      current_components = stored_components
      new_comp_short_config = cmp_config.merge(:title => cmp_instance.js_config[:title] || cmp_instance.class.js_properties[:title]) # here we set the title
      if current_components.empty? or current_components.index{ |c| c[:name] == cmp_name }.nil?
        current_components << new_comp_short_config
      else
        current_components[current_components.index{|c| c[:name] == cmp_name}] = new_comp_short_config
      end
      component_session[:stored_components] = current_components
      @stored_components = nil
      logger.debug "Component: #{components[cmp_name.to_sym]}"
    end
    super(params)
  end

  def user_menu
    [:reset_password.action, :logout.action]
  end

  endpoint :server_remove_tab do |params|
    component_session[:stored_components].delete_if{ |item| item[:name] == params[:name] }
    {}
  end

  private

  def stored_components
    @stored_components = component_session[:stored_components] || []
  end
end