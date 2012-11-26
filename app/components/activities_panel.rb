#encoding: UTF-8
class ActivitiesPanel < Netzke::Basepack::BorderLayoutPanel

  js_property :editable, true

  component :activities_grid do
    {
        :class_name => "ActivitiesGridPanel",
        :model => "Activity",
        :editable => config[:editable],
        :enable_edit_in_form => config[:editable],
        :prohibit_update => (not config[:editable]),
        :scope => lambda{|rel|
          data = session[:activity_filter]
          data ||= {}
          data = data.symbolize_keys
          logger.debug "Data: #{data.inspect}, Rel: #{rel.inspect}"
          if data[:parent] == 'scd'
            rel.where("diagnostic = TRUE")
          elsif data[:parent] == 'all'
            rel.where("id = id")
          elsif data[:parent]
            rel.where("activity_category_id = ?", data[:parent].to_i)
          else
            rel.where("id = id")
          end
        }
    }
  end

  component :activities_tree do
    {
        :class_name => "ActivitiesTree",
        :model => "ActivityCategory",
        :title => "Категории работ",
        :editable => config[:editable]
    }
  end

  js_mixin :activities_panel

  endpoint :set_filter do |params|
    logger.debug "Filter: #{params.inspect}"
    session[:activity_filter] = params
    {:set_result => true}
  end

  endpoint :move_to_folder do |params|
    logger.debug "Move #{params[:children]} to #{params[:parent]}"
    folder = ActivityCategory.find(params[:parent])
    activities = Activity.find(params[:children])
    folder.activities << activities
    {:set_result => true}
  end

  def configuration
    super.tap do |sup|
      sup[:items] = [
          :activities_grid.component(:region => :center, :prevent_header => true),
          :activities_tree.component(:region => :west, :width => 200, :split => true, :prevent_header => true,
                                     :collapsible => true)
          #{
          #    :xtype => "treepanel", :region => :west, :width => 200, :split => true
          #}
      ]
    end
  end

end
