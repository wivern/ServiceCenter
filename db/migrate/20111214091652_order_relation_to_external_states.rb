class OrderRelationToExternalStates < ActiveRecord::Migration
  def self.up
    remove_column :orders, :external_state_id
    create_table :external_states_orders, :id => false do |t|
      t.integer :external_state_id
      t.integer :order_id
    end
    add_index :external_states_orders, [:external_state_id, :order_id], :unique => true
  end

  def self.down
    add_column :orders, :external_state_id, :integer
    drop_table :external_states_orders
  end
end
