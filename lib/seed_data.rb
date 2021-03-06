require 'csv'

module Seed
  module Data
    def seed_data(model_class, file_name, options = {})
      if model_class.count == 0
        table_name = model_class.table_name
        csv_file = CSV.open(file_name, 'r:utf-8', :headers => true)
        model_class.transaction do
          csv_file.each{|row|
            record = model_class.new row.to_hash
            record.save(:validate => false)
          }
        end
        puts "Seeded #{model_class.count} records to #{model_class.name}"
      else
        puts "#{model_class.name} is not empty"
      end
    end

    def write_data(model_class, file_name)
      puts "Exporting #{model_class.name}"
      data = model_class.all
      CSV.open(file_name, 'wb') do |csv|
        csv << model_class.column_names
        data.each{|item|
          csv << model_class.column_names.map{|attr| item[attr]}
        }
      end unless data.empty?
      puts "Export finished, #{data.size} #{model_class.table_name} exported."
    end
  end
end