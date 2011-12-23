class AddOrderSparePartsQuantity < ActiveRecord::Migration
  def self.up
    change_table :order_spare_parts do |t|
      t.integer :quantity, :null => false, :default => 1
    end
  end

  def self.down
    remove_column :order_spare_parts, :quantity
  end
end
