class ModifyPersonStatus < ActiveRecord::Migration
  def self.up
    change_table :person_statuses do |t|
      t.boolean :prevent_sign_in, :default => false
    end
  end

  def self.down
    remove_column :person_statuses, :prevent_sign_in
  end
end
