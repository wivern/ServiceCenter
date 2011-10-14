class CreatePurchasePlaces < ActiveRecord::Migration
  def self.up
    create_table :purchase_places do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :purchase_places
  end
end
