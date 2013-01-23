#encoding: UTF-8
class ActivitiesGrid < Netzke::Basepack::GridPanel

  component :select_activity do
    {
        :class_name => "AddActivityWindow",
        :model => "Activity",
        :columns => activities_columns,
        :initial_sort => ['code', 'ASC'],
        :order_id => config[:order_id],
        :width => 800
    }
  end

  def configuration
    @user = Netzke::Core.current_user
    columns = [ {:name => :activity__code, :summary_type => :count, :read_only => true, :flex => 0, :width => 64},
                {:name => :activity__name, :summary_type => :count, :read_only => true, :flex => 1},
                {:name => :activity__diagnostic, :hidden => true, :read_only => true, :flex => 0, :width => 48}
              ]
    columns << {:name => :price, :read_only => true, :type => :number, :flex => 0, :width => 94,
                          :align => 'right', :renderer => 'this.currencyRenderer', :summary_type => :sum} if @user.has_no_role_engineer?
    columns << {:name => :activity__score, :read_only => true, :type => :number, :align => 'right',
                :flex => 0, :width => 64, :summary_type => :sum} if @user.has_role_engineer?

    columns << {:name => :notes, :flex => 1}
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
    data.map{ |r| r.delete('activity__price__value') }
    super(data, operation)
  end

  protected
  def activities_columns
    columns = [:code, :name]
    columns << :price__value << :price__currency__name unless @user.has_role_engineer?
    columns << :score
  end

end