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
      var panel = this.getChildNetzkeComponent('activities_panel');
      this.grid = panel.getChildNetzkeComponent('activities_grid');
      console.debug('grid', this.grid);
      console.debug('order', this.orderId);
      console.debug('activitywindow', this);
    }
  JS

  js_method :on_select, <<-JS
    function(){
      var selectionModel = this.grid.getSelectionModel();
      if (selectionModel.hasSelection())
        this.selection = selectionModel.getSelection()[0];
      this.closeResult = 'select';
      this.hide();
      this.addActivity({order_id: this.orderId, activity_id: this.selection.data.id },
        function(){
          this.fireEvent('activityadded', this);
        }
      );
    }
  JS

  component :activities_panel do
    {
        :class_name => "ActivitiesPanel",
        :editable => false
    }
  end

  def configuration
    super.tap do |s|
      s[:items] = [:activities_panel.component(:prevent_header => true)]
    end
  end

  def js_config
    super.tap do |res|
      res[:item_id] = "#{name}_#{config[:order_id]}"
    end
  end

end