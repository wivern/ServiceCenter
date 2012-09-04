class Docs::PaymentsReportController < ApplicationController
  respond_to :odt

  def print
    authorize! :print, :payments
    date = Date.parse(params[:date]) if params[:date]
    date ||= Date.today
    @person = Netzke::Core.current_user
    @people = Person.active_and_in_current_organization.order(:name)
    @payments = @people.reject{|u| u.has_no_role_engineer?}.map{|u| {:person_name => u.name, :score => u.scored_at(date)} }
     report = ODFReport::Report.new("#{Rails.root}/public/assets/payments.odt") do |r|
       r.add_field(:today, "#{date.year} #{I18n.t("date.month_names")[date.month]}")
       r.add_field(:organization_name, @person.organization.name)

       r.add_table("TABLE-1", @payments, :header => true) do |t|
         t.add_column(:person_name, :person_name)
         t.add_column(:score, :score)
       end

     end
    send_file(report.generate)
  end

  def current_user
    Netzke::Core.current_user
  end
end
