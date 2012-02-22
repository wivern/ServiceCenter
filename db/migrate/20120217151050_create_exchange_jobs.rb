class CreateExchangeJobs < ActiveRecord::Migration
  def self.up
    create_table :exchange_jobs do |t|
      t.string    :type
      t.string    :name
      t.string    :target_path
      t.datetime  :latest_run
      t.boolean   :success
      t.string    :message
      t.string    :value
      t.time      :run_at
      t.timestamps
    end
  end

  def self.down
    drop_table :exchange_jobs
  end
end
