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

  js_method :on_export_csv, <<-JS
    function(item, e){
       var exportForm = Ext.get("export-form");
       exportForm.dom.submit();
    }
  JS

end