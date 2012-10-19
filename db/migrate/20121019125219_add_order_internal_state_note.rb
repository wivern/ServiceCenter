class AddOrderInternalStateNote < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.text :internal_state_note
    end
  end

  def self.down
    remove_column :orders, :internal_state_note
  end
end
