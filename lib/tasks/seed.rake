require 'seed_data'
namespace :db do
  namespace :seed do

    include Seed::Data

    desc 'Seeds a database with csv files under db/csv directory'
    task :csv => :environment do
      Dir.glob(File.join(Rails.root,'db/csv','*.csv')).each{|file|
        begin
          model_class = File.basename(file).split('.').first.classify.constantize
          puts "Seeding: #{model_class.name}"
          seed_data(model_class, file) if model_class
        rescue Exception => e
          puts e.backtrace
          puts e.message
          puts "#{File.basename file} skipping..."
        end
      }
    end
  end
end