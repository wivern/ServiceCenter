#encoding: UTF-8
class ActivitiesGridPanel < DictionaryGridPanel
  def configuration
    user = Netzke::Core.current_user
    columns = [:code, :name]
    columns << :price if user.has_no_role_engineer?
    columns << :currency__name if user.has_no_role_engineer?
    columns << :diagnostic << :score
    super.merge(
        :columns => columns,
        :force_fit => true,
        :model => "Activity"
    )
  end
end