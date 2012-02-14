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

    desc 'Write data from model MODEL to csv file for later seeding'
    task :write_csv => :environment do
      model = ENV['MODEL']
      #unless model
      #  puts "Usage: rake db:seed:write MODEL=model_name"
      #  exit -1
      #end
      if model
        model = model.constantize
        file = File.join(Rails.root, 'db/csv', "#{model.table_name}.csv")
        if File.exist?(file)
          puts "File #{file} already exists"
          exit -1
        end
        write_data(model, file)
      else
        Dir.glob(File.join(Rails.root,'app/models/*.rb')).each { |mfile| require mfile }
        ActiveRecord::Base.subclasses.each{|model|
          file = File.join(Rails.root, 'db/csv', "#{model.table_name}.csv")
          if File.exist?(file)
            puts "File #{file} already exists, skipping..."
          else
            write_data(model, file)
          end
        }
      end
    end
  end
end