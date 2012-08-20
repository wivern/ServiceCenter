class OrderLocationRelation < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.references :location
    end
  end

  def self.down
    remove_column :orders, :location_id
  end
end
