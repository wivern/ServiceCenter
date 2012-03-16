module ServiceCenter
  module Export
    module Orders
      def self.logger
        Rails.logger
      end

      def self.export_to_directory(dir)
        if File.exists?(dir) and File.directory?(dir)
          file = File.new(File.join(dir, "orders.xml"), 'w')
          orders = Order.where(:status_id => [14,15]) #TODO add status state machine to orders
          file << orders.to_xml(:include => [:spare_parts, :activities])
          file.close
        else
          logger.error "#{dir} doesn't exists or not a directory"
        end
      end
    end
  end
end