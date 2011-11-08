class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.string :name
      t.string :template_file
      t.string :friendly_url
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
