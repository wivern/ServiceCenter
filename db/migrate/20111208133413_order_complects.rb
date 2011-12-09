class OrderComplects < ActiveRecord::Migration
  def self.up
    remove_column :orders, :complect_id
    create_table :complects_orders, :id => false do |t|
      t.integer :order_id
      t.integer :complect_id
    end
    add_index :complects_orders, [:complect_id, :order_id], :unique => true
  end

  def self.down
    remove_index :complects_orders
    drop_table :complects_orders
  end
end
