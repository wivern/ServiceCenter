class CreateActivityCategories < ActiveRecord::Migration
  def self.up
    create_table :activity_categories do |t|
      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.timestamps
    end
  end

  def self.down
    drop_table :activity_categories
  end
end
