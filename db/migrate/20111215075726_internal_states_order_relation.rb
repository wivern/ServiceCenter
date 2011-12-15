class InternalStatesOrderRelation < ActiveRecord::Migration
  def self.up
    remove_column :orders, :internal_state_id
    create_table :internal_states_orders, :id => false do |t|
      t.integer :internal_state_id
      t.integer :order_id
    end
    add_index :internal_states_orders, [:internal_state_id, :order_id], :unique => true
  end

  def self.down
    add_column :orders, :internal_state_id, :integer
    drop_table :internal_states_orders
  end
end
