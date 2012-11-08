class AddOrderActivityPrice < ActiveRecord::Migration
  def self.up
    change_table :order_activities do |t|
      t.float :price
      t.references :currency
    end
    execute <<-SQL
      update order_activities
      set price = prices.value,
          currency_id = prices.currency_id
       from activities join prices on
        prices.priceable_id = activities.id and
        prices.priceable_type = 'Activity'
      where
        activities.id = order_activities.activity_id
    SQL
  end

  def self.down
    remove_column :order_activities, :price
    remove_column :order_activities, :currency_id
  end
end
