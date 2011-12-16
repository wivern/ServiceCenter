#encoding: UTF-8
class ActivitiesGrid < Netzke::Basepack::GridPanel
  # To change this template use File | Settings | File Templates.
  def configuration
    super.merge(
        :class_name => "Netzke::Basepack::GridPanel",
        :model => "OrderActivity",
        :columns => [{:name => :activity__name},
                     {:name => :activity__price, :read_only => true, :type => :number,
                      :align => 'right', :renderer => 'this.currencyRenderer'},
                     :performed_at],
        :force_fit => true
    )
  end

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