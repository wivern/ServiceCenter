require 'dbf'

module ServiceCenter
  module Import
    module SpareParts

      def self.logger
        Rails.logger
      end

      def self.import_from_directory(dir, options = {:mask => '*.dbf'})
        if File.exists?(dir) and File.directory?(dir)
          mask = options[:mask] || '*'
          Dir.glob(File.join(dir, mask)).each{ |f|
              File.delete(f) if self.do_import(f)
          }
        else
          logger.error "Check that #{dir} not exists or not a directory"
        end
      end

      def self.do_import(file)
        logger.info "Starting import from #{file}"
        begin
          spare_parts = DBF::Table.new(file)
          logger.info "Version: #{spare_parts.version}, encoding: #{spare_parts.encoding}"
          spare_parts.each { |rec|
            import_record rec
          }
        rescue Exception => e
          logger.error e.message
          logger.error e.backtrace
          logger.error "Import for #{file} has failed, data was not fully imported."
          false
          #raise e
        end
        logger.info "Import of #{file} has finished"
        true
      end

      private
      def self.import_record(rec)
        if rec.is_service == 'T'
          #is a service
          model = Activity.find_or_initialize_by_code(rec.code)
        else
          #is a spare_part
          model = SparePart.find_or_initialize_by_part_number(rec.code)
        end
        model.price = rec.price
        model.currency = Currency.find_by_char_code(rec.currency)
        model.name = rec.name
        model.save
      end
    end
  end
end