require 'csv'

class AnalysisController < ApplicationController

  before_filter :authenticate_person!
  respond_to :csv

  def index
    raise CanCan::AccessDenied unless current_person.has_role_analyst?
    data = session[:analysis_data]
    data ||= {}
    data = data.symbolize_keys
    data.reject!{|k,v| v == -1}
    rel = Order
    rel = rel.where("organization_id = ?",data[:organization]) if data[:organization] && data[:organization] != -1
    rel = rel.where("applied_at >= ?", data[:starting_date]) if data[:starting_date]
    rel = rel.where("applied_at <= ?", data[:finish_date]) if data[:finish_date]
    rel = rel.where("repair_type_id = ?", data[:repair_type]) if data[:repair_type] && data[:repair_type] != -1
    rel = rel.where("status_id = ?", data[:status]) if data[:status]
    rel = rel.where("producer_id = ?", data[:producer]) if data[:producer]
    rel = rel.where("manager_id = ?", data[:manager]) if data[:manager]
    rel = rel.where("engineer_id = ?", data[:engineer]) if data[:engineer]
    rel = rel.order(:ticket)
    csv_data = CSV.generate do |csv|
      csv << [Order.human_attribute_name(:ticket), Order.human_attribute_name(:applied_at),
        Order.human_attribute_name(:product_passport__product__name),
        Order.human_attribute_name(:product_passport__factory_number),
        Order.human_attribute_name(:product_passport__producer__name),
        Order.human_attribute_name(:repair_type__name),
        Order.human_attribute_name(:status__name),
          Order.human_attribute_name(:manager__name),
          Order.human_attribute_name(:engineer),
          Order.human_attribute_name(:activities_amount),
          Order.human_attribute_name(:activities_count),
          Order.human_attribute_name(:spare_parts_amount),
          Order.human_attribute_name(:total_amount),
          Order.human_attribute_name(:total_amount_with_discount),
          Order.human_attribute_name(:diag_price),
          Order.human_attribute_name(:work_performed_at),
          Order.human_attribute_name(:actual_deliver_at),
          Order.human_attribute_name(:customer__name),
          Order.human_attribute_name(:spare_parts_printable),
          Order.human_attribute_name(:reason),
          Order.human_attribute_name(:activities_printable) ]
      rel.each {|r|
        logger.debug r.inspect
        csv << [r.ticket, r.applied_at, safe_str(r.product_passport.product),
            r.product_passport.factory_number, safe_str(r.product_passport.producer),
            safe_str(r.repair_type), safe_str(r.status), safe_str(r.manager),
            safe_str(r.engineer), r.activities_amount, r.activities_count, r.spare_parts_amount,
            r.total_amount, r.total_amount_with_discount, r.diag_price, r.work_performed_at,
            r.actual_deliver_at, safe_str(r.customer), r.spare_parts_printable,
            r.reason, r.activities_printable]
      }
    end
    send_data csv_data, :type => "text/plain"
  end

  private
  def safe_str(obj, method = :name)
    obj.nil? ? "": obj.send(method)
  end
end
