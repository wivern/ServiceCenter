class ProductRelations < ActiveRecord::Migration
  def self.up
    change_table :products do |t|
      t.references :producer
    end
  end

  def self.down
    remove_column :products, :producer_id
  end
end
