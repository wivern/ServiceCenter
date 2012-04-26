#encoding: UTF-8
class ReportsGrid < Netzke::Basepack::Grid

  component :reports_repair_types_form do
    form_config = {
        :class_name => "Netzke::Basepack::FormPanel",
        :model => "Report",
        :prevent_header => true,
        :bbar => false,
        :items => [
            {:name => :name, :read_only => true},
            {:xtype => :checkboxgroup, :vertical => true,
                :columns => 1,
                :hide_label => true,
                :border => true,
                :items => available_repair_type_controls }
        ]
    }

    {
      :lazy_loading => true,
      :class_name => "Netzke::Basepack::GridPanel::RecordFormWindow",
      :title => "Виды ремонта",
      :button_align => "right",
      :close_action => "hide",
      :items => [form_config]
    }.deep_merge(config[:edit_form_window_config] || {})
  end

  def deliver_component_endpoint(params)
    components[:reports_repair_types_form][:items].first.merge!(:record_id => params[:record_id].to_i) if params[:name] == 'reports_repair_types_form'
    super
  end

private
  def available_repair_type_controls
    RepairType.all.map{|r|
      {:box_label => r.name, :xtype => :checkbox, :name => :repair_types, :input_value => r.id}
    }
  end

end