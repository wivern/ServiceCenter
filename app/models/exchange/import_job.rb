#encoding: UTF-8
require 'service_center/import/spare_parts'

module Exchange
  class ImportJob < ExchangeJob

    protected
    def do_execute(params = {})
      ServiceCenter::Import::SpareParts.import_from_directory(target_path)
    end
  end
end