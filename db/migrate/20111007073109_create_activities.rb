class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :name
      t.decimal :price, :precision => 8, :scale => 2
      t.references :currency
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
