class CreatePersonStatuses < ActiveRecord::Migration
  def self.up
    create_table :person_statuses do |t|
      t.string :name

      t.timestamps
    end
    add_column :people, :person_status_id, :integer
    PersonStatus.create(:name => I18n.t("fired"))
  end

  def self.down
    drop_table :person_statuses
    remove_column :people, :person_status_id
  end
end
