class AddOrganizationAttributes < ActiveRecord::Migration
  def self.up
    change_table :organizations do |t|
      t.string :city
      t.string :address
      t.string :working_time
      t.string :phone
      t.integer :responsible_id
    end
  end

  def self.down
    remove_column :organizations, :city
    remove_column :organizations, :address
    remove_column :organizations, :working_time
    remove_column :organizations, :phone
    remove_column :organizations, :responsible_id
  end
end
