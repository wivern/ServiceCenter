class ProductRelations < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.references :producer
    end
    #rename_column :product_passports, :product_name_id, :product_id
  end

  def self.down
    remove_column :products, :producer_id
    #rename_column :product_passports, :product_id, :product_name_id
  end
end
