require 'service_center'

namespace :sc do
  namespace :import do

    desc 'Imports spare parts and activities from dbf file specified by FILE parameter'
    task :spare_parts => :environment do
      file = ENV['FILE']
      unless file
        puts "Use: rake sc:import:spare_parts FILE=your_file.dbf"
        exit
      end
      ServiceCenter::Import::SpareParts.do_import(file)
      puts "Import finished"
    end
  end
end