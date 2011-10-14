class CreateRepairTypes < ActiveRecord::Migration
  def self.up
    create_table :repair_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :repair_types
  end
end
