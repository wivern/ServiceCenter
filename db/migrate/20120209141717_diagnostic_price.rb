class DiagnosticPrice < ActiveRecord::Migration
  def self.up
    change_table :activities do |t|
      t.boolean :diagnostic, :default => false
    end
    change_table :orders do |t|
      t.integer :diagnostic_activity_id
    end
    add_index :orders, [:diagnostic_activity_id]
  end

  def self.down
    remove_column :activities, :diagnostic
    remove_index :orders, [:diagnostic_activity_id]
    remove_column :orders, :diagnostic_activity_id
  end
end
