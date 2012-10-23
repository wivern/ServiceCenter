class AddOrderActivityNote < ActiveRecord::Migration
  def self.up
    change_table :order_activities do |t|
      t.text :notes
    end
  end

  def self.down
    remove_column :order_activities, :notes
  end
end
