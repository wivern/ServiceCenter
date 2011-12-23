class AddRepairTypeAndReportRelation < ActiveRecord::Migration
  def self.up
    create_table :repair_types_reports, :id => false do |t|
      t.integer :repair_type_id, :null => false
      t.integer :report_id, :null => false
    end
    add_index :repair_types_reports, [:repair_type_id, :report_id], :unique => true
  end

  def self.down
    drop_table :repair_types_reports
  end
end
