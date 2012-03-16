#encoding: UTF-8
module Maintenance
  class DiagnosticForm < Netzke::Basepack::FormPanel

    include ServiceCenter::ExtendedForm

    component :select_internal_state do
        {
            :class_name => "DictionaryWindow",
            :model => "InternalState",
            :columns => [:name],
            :prohibit_modify => true,
            :initial_sort => ['name', 'ASC']
        }
    end

    def default_config
      super.merge(:model => "Order")
    end

    def configuration
      super.tap do |c|
        c[:items] = [
            :layout => :hbox, :border => false, :defaults => {:border => false},
            :items => [
                {:flex => 1, :defaults => {:anchor => '-8'},
                 :items => [
                     {:name => :defects__name, :read_only => true, :submit_value => false},
                     {:name => :internal_states__name, :xtype => :netzkepopupselect, :height => 140,
                      :auto_load_store => true, :selection_component => :select_internal_state}
                 ]
                },
                {:flex => 1, :defaults => {:anchor => '100%'},
                 :items => [
                     {:name => :actual_defect},
                     {:name => :result}
                 ]}
            ]
        ]
      end
    end
  end
end