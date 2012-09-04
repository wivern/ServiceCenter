class AddCompleteToStatus < ActiveRecord::Migration
  def self.up
    change_table :statuses do |t|
      t.boolean :complete, :default => false
      t.boolean :ready, :default => false
      t.boolean :performed, :default => false
    end
  end

  def self.down
    remove_column :statuses, :complete
    remove_column :statuses, :ready
    remove_column :statuses, :performed
  end
end
