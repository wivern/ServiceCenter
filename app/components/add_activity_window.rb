#encoding: UTF-8
class AddActivityWindow < DictionaryWindow

  endpoint :add_activity do |params|
    order_id = params[:order_id]
    activity_id = params[:activity_id]
    if order_id and activity_id
      OrderActivity.create(:order_id => order_id, :activity_id => activity_id)
      {:set_result => true}
    else
      {:set_result => false}
    end
  end

  js_method :init_component, <<-JS
    function(){
      this.callParent();
      this.addEvents('activityadded');
    }
  JS

  js_method :on_select, <<-JS
    function(){
      var selectionModel = this.items.first().getSelectionModel();
      if (selectionModel.hasSelection())
        this.selection = selectionModel.getSelection()[0];
      console.debug('selection', this.selection);
      this.closeResult = 'select';
      this.hide();
      this.addActivity({order_id: this.orderId, activity_id: this.selection.data.id },
        function(){
          this.fireEvent('activityadded', this);
        }
      );
    }
  JS

end