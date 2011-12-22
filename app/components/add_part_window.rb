class AddPartWindow < DictionaryWindow

  js_mixin :add_part_window

  endpoint :add_part do |params|
    order_id = params[:order_id]
    part_id = params[:part_id]
    if (order_id && part_id)
      OrderSparePart.create(:order_id => order_id, :spare_part_id => part_id)
      {:set_result => true}
    else
      {:set_result => false}
    end
  end
  
  js_method :on_select, <<-JS
    function(){
      var selectionModel = this.items.first().getSelectionModel();
      if (selectionModel.hasSelection())
        this.selection = selectionModel.getSelection()[0];
      console.debug('selection', this.selection);
      this.closeResult = 'select';
      this.hide();
      this.addPart({order_id: this.orderId, part_id: this.selection.data.id },
        function(){
          this.fireEvent('partsadded', this);
        }
      );
    }
  JS
  
end