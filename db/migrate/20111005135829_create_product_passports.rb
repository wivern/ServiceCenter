class CreateProductPassports < ActiveRecord::Migration
  def self.up
    create_table :product_passports do |t|
      t.references :producer
      t.references :product_name
      t.string :factory_number
      t.string :guarantee_stub_number
      t.references :purchase_place
      t.date   :purchased_at
      t.references :dealer
      t.timestamps
    end
  end

  def self.down
    drop_table :product_passports
  end
end
