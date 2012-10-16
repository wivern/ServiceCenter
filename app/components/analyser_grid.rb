#encoding: UTF-8
class AnalyserGrid < Netzke::Basepack::GridPanel
  def default_bbar
    res = []
    res << :search.action if config[:enable_extended_search]
  end

  action :export_csv do
    {
        :text => 'Экспорт',
        :icon => :page_white_excel
    }
  end

  def configuration
    super.tap{|c|
      c[:tbar] = [:export_csv.action]
    }
  end

  js_mixin :analyser_grid

  js_method :on_export_csv, <<-JS
    function(item, e){
       var exportForm = Ext.get("export-form");
       exportForm.dom.submit();
    }
  JS

  endpoint :get_list_filter_data do |params|
    get_list_filter_data(params)
  end

  protected

  def get_list_filter_data(params = {})
    logger.debug "list filter params: #{params.inspect}"
    model = params['model'].camelize.constantize
    @items = model.scoped
    #params[:scope].split('.').each{|scope| @items = @items.send(scope)} if params[:scope]
    @items = @items.send(params[:scope]) if params[:scope]
    @items = @items.order(:name)
    @items.map{|c| {:id => c.id, :name => c.name} }
  end

end