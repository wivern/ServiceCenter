#encoding: UTF-8
class ActivitiesGrid < Netzke::Basepack::GridPanel

  component :select_activity do
    {
        :class_name => "AddActivityWindow",
        :model => "Activity",
        :columns => [:code, :name, :price, :currency__name],
        :initial_sort => ['code', 'ASC'],
        :order_id => config[:order_id]
    }
  end

  def configuration
    @user = Netzke::Core.current_user
    columns = [ {:name => :activity__code, :summary_type => :count},
                {:name => :activity__name, :summary_type => :count} ]
    columns << {:name => :activity__price, :read_only => true, :type => :number,
                          :align => 'right', :renderer => 'this.currencyRenderer', :summary_type => :sum} if not @user.has_role_engineer?
    columns << :performed_at
    super.merge(
        :class_name => "Netzke::Basepack::GridPanel",
        :model => "OrderActivity",
        :features => [{:ftype => 'summary'}],
        :columns => columns,
        :force_fit => true,
        :prohibit_update => false,
        :enable_edit_in_form => false
    )
  end

  js_mixin :activities_grid

  #TODO get currency format from current locale
  js_method :currency_renderer, <<-JS
    function (value){
      return Ext.util.Format.currency(value, ' руб.', 2, true);
    }
  JS

  def process_data(data, operation)
    data.map{ |r| r.delete('activity__price') }
    super(data, operation)
  end

end