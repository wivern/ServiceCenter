class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.float :value
      t.references :priceable, :polymorphic => true
      t.references :currency
      t.references :organization
      t.timestamps
    end
    execute <<-SQL
      insert into prices(priceable_id, priceable_type, value, organization_id, currency_id)
        select a.id, 'SparePart', a.price, o.id, a.currency_id from spare_parts a, organizations o;
    SQL
    execute <<-SQL
      insert into prices(priceable_id, priceable_type, value, organization_id, currency_id)
        select a.id, 'Activity', a.price, o.id, a.currency_id from activities a, organizations o
    SQL
  end

  def self.down
    drop_table :prices
  end
end
