class CreateOrderActivities < ActiveRecord::Migration
  def self.up
    create_table :order_activities do |t|
      t.references :order
      t.references :activity
      t.date :performed_at
      t.timestamps
    end
    add_index :order_activities, [:order_id, :activity_id], :unique => true
  end

  def self.down
    drop_table :order_activities
  end
end
