class OrderResultModify < ActiveRecord::Migration
  def self.up
    remove_column :orders, :result_id
    add_column :orders, :result, :text
  end

  def self.down
    remove_column :orders, :result
    add_column :orders, :result_id, :integer
  end
end
