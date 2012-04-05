#encoding: UTF-8
class PartsGrid  < Netzke::Basepack::GridPanel

  js_include "#{File.dirname(__FILE__)}/dialog_trigger_field/javascripts/dialog_trigger_field.js"

  js_mixin :parts_grid

  component :select_spare_part do
    {
        :class_name => "AddPartWindow",
        :model => "SparePart",
        :columns => [:part_number, :name, :price, :currency__name],
        :initial_sort => ['part_number', 'ASC'],
        :order_id => config[:order_id]
    }
  end

  def configuration
    @user = Netzke::Core.current_user
    columns = [{:name => :spare_part__name, :read_only => true, :summary_type => "count", :data_index => "spare_part__name"},
                {:name => :spare_part__part_number, :read_only => true}]
    columns << {:name => :price, :read_only => true, :align => :right, :renderer => 'this.currencyRenderer'} if @user.has_no_role_engineer?
    columns << {:name => :quantity, :align => :right, :summary_type => "count"}
    columns << {:name => :amount, :read_only => true, :align => :right, :summary_type => "sum", :data_index => "amount",
                  :renderer => 'this.currencyRenderer'} if @user.has_no_role_engineer?
    super.merge(
        :class_name => "Netzke::Basepack::GridPanel",
        :model => "OrderSparePart",
        :features => [{:ftype => "summary"}],
        :columns => columns,
        :force_fit => true,
        :prohibit_update => false,
        :enable_edit_in_form => false
    )
  end

  #def editor_for_association
  #  {:xtype => :selecttriggerfield, :assoc => true, :parent_id => self.global_id}
  #end

  #TODO get currency format from current locale
  js_method :currency_renderer, <<-JS
    function (value){
      return Ext.util.Format.currency(value, ' руб.', 2, true);
    }
  JS

  def process_data(data, operation)
    data.map{ |r| r.delete('spare_part__part_number') }
    super(data, operation)
  end

end