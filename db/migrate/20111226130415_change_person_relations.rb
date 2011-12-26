class ChangePersonRelations < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.remove :position
      t.references :organization
      t.references :position
    end
  end

  def self.down
    remove_column :people, :organization_id
    remove_column :people, :position_id
  end
end
