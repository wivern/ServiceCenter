class AddOrderInheritance < ActiveRecord::Migration
  def self.up
    add_column :orders, :created_from_id, :integer
    add_index :orders, :created_from_id
  end

  def self.down
    remove_index :orders, :created_from_id
    remove_column :orders, :created_from_id
  end
end
