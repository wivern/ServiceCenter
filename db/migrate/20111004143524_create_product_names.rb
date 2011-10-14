class CreateProductNames < ActiveRecord::Migration
  def self.up
    create_table :product_names do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :product_names
  end
end
