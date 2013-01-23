#encoding: UTF-8
class ActivitiesGridPanel < DictionaryGridPanel

  js_property :editable, true

  def configuration
    user = Netzke::Core.current_user
    columns = [{:name => :code, :width => 64, :flex => 0}, {:name => :name, :flex => 1}]
    columns << {:name => :price__value, :read_only => true, :flex => 0, :width => 64} if user.has_no_role_engineer?
    columns << {:name => :diagnostic, :flex => 0, :width => 48} << {:name => :score, :flex => 0, :width => 48}
    columns << {:name => :price__currency__name, :read_only => true, :hidden => true, :flex => 0, :width => 64} if user.has_no_role_engineer?
    super.merge(
        :columns => columns,
        :force_fit => true,
        :model => "Activity"
    )
  end

  js_mixin :activities_grid_panel
end