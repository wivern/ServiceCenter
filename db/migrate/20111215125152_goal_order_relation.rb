class GoalOrderRelation < ActiveRecord::Migration
  def self.up
    remove_column :orders, :goal_id
    create_table :goals_orders, :id => false do |t|
      t.integer :goal_id
      t.integer :order_id
    end
    add_index :goals_orders, [:goal_id, :order_id], :unique => true
  end

  def self.down
    add_column :orders, :goal_id, :integer
    drop_table :goals_orders
  end
end
