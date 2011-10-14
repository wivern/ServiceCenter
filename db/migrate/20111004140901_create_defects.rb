class CreateDefects < ActiveRecord::Migration
  def self.up
    create_table :defects do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :defects
  end
end
