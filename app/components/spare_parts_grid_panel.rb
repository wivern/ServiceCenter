#encoding: UTF-8
class SparePartsGridPanel < DictionaryGridPanel
  def configuration
    columns = [
        :part_number, :name,
        {:name => :price__value, :read_only => true},
        {:name => :price__currency__name, :read_only => true}
    ]
    super.merge(
      :columns => columns,
      :force_fit => true,
      :model => "SparePart"
    )
  end
end