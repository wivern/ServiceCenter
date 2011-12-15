class GroundOrderRelation < ActiveRecord::Migration
  def self.up
    create_table :grounds_orders, :id => false do |t|
      t.integer :ground_id
      t.integer :order_id
    end
    add_index :grounds_orders, [:ground_id, :order_id], :unique => true
  end

  def self.down
    drop_table :grounds_orders
  end
end
