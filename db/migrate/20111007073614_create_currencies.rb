class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :name
      t.string :full_name
      t.string :char_code, :limit => 3
      t.integer :num_code
      t.timestamps
    end
  end

  def self.down
    drop_table :currencies
  end
end
