#encoding: UTF-8
class ActivitiesPanel < Netzke::Basepack::BorderLayoutPanel

  component :activities_grid do
    {
        :class_name => "ActivitiesGridPanel",
        :model => "Activity"
    }
  end

  component :activities_tree do
    {
        :class_name => "ActivitiesTree",
        :model => "ActivityCategory"
    }
  end

  def configuration
    super.tap do |sup|
      sup[:items] = [
          :activities_grid.component(:region => :center, :prevent_header => true),
          :activities_tree.component(:region => :west, :width => 200, :split => true, :prevent_header => true)
          #{
          #    :xtype => "treepanel", :region => :west, :width => 200, :split => true
          #}
      ]
    end
  end

end
