require 'service_center'

namespace :sc do
  namespace :import do

    desc 'Imports spare parts and activities from dbf file specified by FILE parameter'
    task :spare_parts => :environment do
      file = ENV['FILE']
      enc = ENV['ENCODING'] || 'cp1251'
      format = ENV['FORMAT'] || :csv
      format = format.to_sym
      unless file
        puts "Use: rake sc:import:spare_parts FILE=your_file.dbf [ENCODING=cp866]"
        exit
      end
      ServiceCenter::Import::SpareParts.do_import(file, :encoding => enc, :format => format)
      puts "Import finished"
    end
  end
end