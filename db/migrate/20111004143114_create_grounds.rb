class CreateGrounds < ActiveRecord::Migration
  def self.up
    create_table :grounds do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :grounds
  end
end
