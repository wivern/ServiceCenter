class AddScoreToActivity < ActiveRecord::Migration
  def self.up
    change_table :activities do |t|
      t.integer :score, :default => 0
    end
  end

  def self.down
    remove_column :activities, :score
  end
end
