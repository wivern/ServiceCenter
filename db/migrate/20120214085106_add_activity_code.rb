class AddActivityCode < ActiveRecord::Migration
  def self.up
    add_column :activities, :code, :string
  end

  def self.down
    remove_column :activities, :code
  end
end
