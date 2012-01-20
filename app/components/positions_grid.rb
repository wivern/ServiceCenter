#encoding: utf-8
class PositionsGrid < Netzke::Basepack::GridPanel
  # To change this template use File | Settings | File Templates.

  js_mixin :positions_grid

  component :edit_position_form do
    form_config = {
        :class_name => "Netzke::Basepack::FormPanel",
        :model => "Position",
        :prevent_header => true,
        :bbar => false,
        :items => [
            {:name => :name},
            {:xtype => :checkboxgroup, :vertical => true,
                :columns => 1,
                :hide_label => true,
                :border => true,
                :items => available_roles_controls }
        ]
    }

    {
      :lazy_loading => true,
      :class_name => "Netzke::Basepack::GridPanel::RecordFormWindow",
      :title => "Edit #{data_class.model_name.human}",
      :button_align => "right",
      :close_action => "hide",
      :items => [form_config]
    }.deep_merge(config[:edit_form_window_config] || {})
  end

  def deliver_component_endpoint(params)
    components[:edit_position_form][:items].first.merge!(:record_id => params[:record_id].to_i) if params[:name] == 'edit_position_form'
    super
  end

  def available_roles_controls
    Position.available_roles.map{ |k, v|
      {:box_label => v[:name], :xtype => :checkbox, :name => :roles, :input_value => k.to_s}
    }.sort_by{ |e| e[:box_label] }
  end

end