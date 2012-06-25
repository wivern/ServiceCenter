module Charts
  class Chart < Netzke::Base

    js_base_class "Ext.chart.Chart"

    class_config_option :theme, "Blue"

    class_config_option :chart_data_url, ""

    js_mixin :chart

  end
end