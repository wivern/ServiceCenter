#encoding: UTF-8
class SparePartsGridPanel < DictionaryGridPanel


  def configuration
    columns = [
        {:name => :part_number, :flex => 0, :width => 96},
        {:name => :name, :flex => 1},
        {:name => :price__value, :read_only => true, :flex => 0, :width => 96, :align => :right, :renderer => 'this.currencyRenderer'},
        {:name => :price__currency__name, :read_only => true, :hidden => true}
    ]
    super.merge(
      :columns => columns,
      :force_fit => true,
      :model => "SparePart"
    )
  end

  js_method :currency_renderer, <<-JS
    function (value){
      return Ext.util.Format.currency(value, ' руб.', 2, true);
    }
  JS

end