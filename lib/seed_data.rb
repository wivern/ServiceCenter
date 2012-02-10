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
  end
end