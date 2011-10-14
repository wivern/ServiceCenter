class AddOrderDiagResult < ActiveRecord::Migration
  def self.up
    add_column :orders, :result_id, :integer
  end

  def self.down
    remove_column :orders, :result_id
  end
end
