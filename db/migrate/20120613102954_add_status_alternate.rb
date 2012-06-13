class AddStatusAlternate < ActiveRecord::Migration
  def self.up
    add_column :statuses, :customer_info, :string
  end

  def self.down
    remove_column :statuses, :customer_info
  end
end
