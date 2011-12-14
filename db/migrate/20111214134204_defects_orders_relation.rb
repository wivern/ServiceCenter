class DefectsOrdersRelation < ActiveRecord::Migration
  def self.up
    remove_column :orders, :actual_defect
    create_table :defects_orders, :id => false do |t|
      t.integer :defect_id
      t.integer :order_id
    end
    add_index :defects_orders, [:defect_id, :order_id], :unique => true
  end

  def self.down
    add_column :orders, :actual_defects, :text
    drop_table :defects_orders
  end
end
