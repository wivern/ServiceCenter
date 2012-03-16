#encoding: UTF-8
module Maintenance
  class MaintenanceForm < Netzke::Basepack::FormPanel
    include ServiceCenter::ExtendedForm

    def default_config
      super.merge(:model => "Order", :record_id => 0, :align => :stretch)
    end

    component :activities do
      {
          :class_name => "ActivitiesGrid",
          :strong_default_attrs => {:order_id => config[:record_id]},
          :scope => ["order_id = ?", config[:record_id]],
          :order_id => config[:record_id],
          :prevent_header => true,
          :min_height => 300
      }
    end

    component :spare_parts do
      {
          :class_name => "PartsGrid",
          :strong_default_attrs => {:order_id => config[:record_id]},
          :scope => ["order_id = ?", config[:record_id]],
          :order_id => config[:record_id],
          :prevent_header => true,
          :columns => [:name, :part_number, :quantity]
      }
    end

    js_method :grids_load, <<-JS
      function(recordId){
        this.netzkeLoad({id: recordId});
        console.debug('maintenance_form', this);
        this.getComponent('activities').store.load();
        this.getComponent('spareParts').store.load();
      }
    JS

    def configuration
      super.tap do |c|
        c[:items] = [{
                         :xtype => :tabpanel, :flex => 1, :align => "stretch", :body_padding => 5, :plain => true, :active_tab => 0,
                         :layout => { :type => :fit, :align => :stretch, :pack => :start},
                         :items => [
                             :activities.component(:title => "Работы", :flex => 1,
                                                   :layout => { :type => :fit, :align => :stretch, :pack => :start}),
                             :spare_parts.component(:title => "Запчасти")
                         ]
                     }
        ]
      end
    end

  end
end