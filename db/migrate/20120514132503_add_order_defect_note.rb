class AddOrderDefectNote < ActiveRecord::Migration
  def self.up
    add_column :orders, :defect_note, :text
  end

  def self.down
    remove_column :orders, :defect_note
  end
end
