module ServiceCenter
  module Reportable
    extend ActiveSupport::Concern
    included do

      js_mixin "#{File.dirname(__FILE__)}/../../app/components/javascripts/print_mixin.js"
      js_include "#{File.dirname(__FILE__)}/../../app/components/javascripts/print.js"

      endpoint :get_print_options do |params|
        order = Order.find(params[:orderId])
        reports = order.repair_type.reports.map{ |r|
          {:text => r.name, :reportId => r.friendly_url, :orderId => params[:orderId]}
        }
        {:set_result => reports}
      end
    end

  end
end