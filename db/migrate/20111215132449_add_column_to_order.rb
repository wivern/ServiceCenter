class AddColumnToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :actual_defect, :text
  end

  def self.down
    remove_column :orders, :actual_defect
  end
end
