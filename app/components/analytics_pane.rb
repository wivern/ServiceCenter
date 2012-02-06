#encoding: UTF-8
class AnalyticsPane < Netzke::Basepack::BorderLayoutPanel

  component :analisys_form do
    {
        :class_name => 'AnalyserForm',
        :region => :east,
        :width => 300,
        :collapsible => true,
        :collapsed => false
    }
  end

  def configuration
    super.tap do |sup|
      sup[:items] = [
          {:region => :center, :prevent_header => false},
          :analisys_form.component
      ]
    end
  end

  end