class CreateExternalStates < ActiveRecord::Migration
  def self.up
    create_table :external_states do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :external_states
  end
end
