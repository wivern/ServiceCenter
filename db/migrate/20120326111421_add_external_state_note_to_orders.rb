class AddExternalStateNoteToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :external_state_note, :text
  end

  def self.down
    remove_column :orders, :external_state_note
  end
end
