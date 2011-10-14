class CreateInternalStates < ActiveRecord::Migration
  def self.up
    create_table :internal_states do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :internal_states
  end
end
