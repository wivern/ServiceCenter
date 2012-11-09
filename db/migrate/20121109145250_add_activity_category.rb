class AddActivityCategory < ActiveRecord::Migration
  def self.up
    change_table :activities do |t|
      t.references :activity_category
    end
  end

  def self.down
    remove_column :activities, :activity_category
  end
end
