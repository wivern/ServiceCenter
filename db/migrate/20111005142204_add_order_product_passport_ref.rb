class AddOrderProductPassportRef < ActiveRecord::Migration
  def self.up
    add_column :orders, :product_passport_id, :integer
  end

  def self.down
    remove_column :orders, :product_passport_id
  end
end
