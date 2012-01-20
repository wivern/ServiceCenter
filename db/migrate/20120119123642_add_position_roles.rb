class AddPositionRoles < ActiveRecord::Migration
  def self.up
    change_table :positions do |t|
      t.text :roles, :default => [].to_yaml
    end
  end

  def self.down
    remove_column :positions, :roles
  end
end
