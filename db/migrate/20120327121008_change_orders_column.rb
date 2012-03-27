class ChangeOrdersColumn < ActiveRecord::Migration
  def self.up
    change_table :orders do |t|
      t.remove :service_phone_agreement
      t.boolean :service_phone_agreement, :default => false
    end
  end

  def self.down
    change_table :orders do |t|
      t.remove :service_phone_agreement
      t.text :service_phone_agreement
    end
  end
end
