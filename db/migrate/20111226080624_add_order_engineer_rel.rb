class AddOrderEngineerRel < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.references :engineer
    end
  end

  def self.down
    remove_column :orders, :engineer_id
  end
end
