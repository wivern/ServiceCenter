class CreateOrderSpareParts < ActiveRecord::Migration
  def self.up
    create_table :order_spare_parts do |t|
      t.references  :order
      t.references  :spare_part
      t.references  :currency
      t.decimal     :price, :precision => 9, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :order_spare_parts
  end
end
