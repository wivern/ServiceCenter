class OrderOrganizationRel < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.references :organization
    end
  end

  def self.down
    remove_column :orders, :organization_id
  end
end
