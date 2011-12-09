class Docs::PrintsController < ApplicationController
  def print
    @report = Report.find_by_friendly_url(params[:report])
    @order = Order.find(params[:id])
    report = ODFReport::Report.new("#{RAILS_ROOT}/public/assets/#{@report.template_file}") do |r|
      @order.attributes.each { |attr, value|
        logger.debug "Adding field #{attr} with #{value}"
        r.add_field(attr, value.to_s) }
      @order.class.reflect_on_all_associations.each { |ref| add_reflection(r, ref, @order.send(ref.name)) unless [:has_many, :has_and_belongs_to_many].include? ref.macro }
    end
    report_file_name = report.generate
    send_file(report_file_name)
  end

  private
  def add_reflection(report, reflection, data)
    reflection.klass.columns.each { |attr|
      field_name = "#{reflection.name}_#{attr.name}"
      if attr.name != 'id'
        value = data.send("#{attr.name}")
        logger.debug "Adding field #{field_name} with #{value}"
        report.add_field(field_name, value)
      end
    } if data
    reflection.klass.reflect_on_all_associations.each{ |ref| add_reflection(report, ref, data.send(ref.name))  unless [:has_many, :has_and_belongs_to_many].include? ref.macro}
  end

end
