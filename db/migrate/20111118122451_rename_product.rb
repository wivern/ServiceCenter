class RenameProduct < ActiveRecord::Migration
  def self.up
    rename_table :product_names, :products
  end

  def self.down
    rename_table :products, :product_names
  end
end
