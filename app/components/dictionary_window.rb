class DictionaryWindow < Netzke::Basepack::Window

  js_properties :width => "50%",
                :height => "50%",
                :close_action => "hide",
                :buttons => [:select.action, :cancel.action],
                :modal => true,
                :autofill_column => "name"

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
        :columns => config[:columns],
        :scope => config[:scope],
        :prohibit_update => true,
        :prohibit_delete => true,
        :bbar => nil,
        :lazy_loading => false
    }
  end

  js_method :init_component, <<-JS
    function(){
      this.callParent();
      var grid = this.items.first();
      if (this.autofillColumn){
        Ext.each(grid.columns, function(e, index){
          if (e.name == this.autofillColumn)
              e.flex = 1;
        }, this);
      }
      if (this.initialSort)
        grid.store.sort(this.initialSort);
      this.on('show', function(){
        this.selection = null;
        this.closeResult = 'cancel';
      }, this);
    }
  JS

  js_method :on_select, <<-JS
    function(){
      var selectionModel = this.items.first().getSelectionModel();
      if (selectionModel.hasSelection())
        this.selection = selectionModel.getSelection()[0];
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