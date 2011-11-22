class DictionaryWindow < Netzke::Basepack::Window

  action :select do
    { :text => I18n.t('views.actions.select.text') }
  end

  action :cancel do
    { :text => I18n.t('views.actions.cancel.text')}
  end

  def configuration
    super.tap do |s|
      s[:items] = [:grid_panel.component(:prevent_header => true)]
      s[:title] = I18n.t('views.dictionary_window.title')
    end
  end

  component :grid_panel do
    {
        :class_name => "Netzke::Basepack::GridPanel",
        :model => config[:model],
        :lazy_loading => false
    }
  end

  js_method :init_component, <<-JS
    function(){
      this.callParent();
      this.on('show', function(){
        this.closeResult = 'cancel';
      }, this);
    }
  JS

  js_method :on_select, <<-JS
    function(){
      this.closeResult = 'select';
      this.hide();
    }
  JS

  js_method :on_cancel, <<-JS
    function(){
      this.hide();
    }
  JS

end