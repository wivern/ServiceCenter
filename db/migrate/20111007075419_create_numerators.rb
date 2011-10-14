class CreateNumerators < ActiveRecord::Migration
  def self.up
    create_table :numerators do |t|
      t.string :name, :null => false
      t.integer :repair_type_id, :null => true
      t.integer :current_value, :default => 0
    end
  end

  def self.down
    drop_table :numerators
  end
end
