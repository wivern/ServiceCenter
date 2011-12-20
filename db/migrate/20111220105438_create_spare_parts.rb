class CreateSpareParts < ActiveRecord::Migration
  def self.up
    create_table :spare_parts do |t|
      t.string :name
      t.string :part_number
      t.decimal :price, :precision => 9, :scale => 2
      t.references :currency
      t.timestamps
    end
    add_index :spare_parts, :part_number, :unique => true
  end

  def self.down
    drop_table :spare_parts
  end
end
