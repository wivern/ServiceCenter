class ExportController < ApplicationController

  respond_to :xml

  # parameters:
  # from - from date
  # till - till date or current date if none
  def index
    @from = Date.parse params[:from]
    @till = params[:till] || Date.today
    @orders = Order.performed.completed.by_deliver_date(@from, @till) + Order.ready.by_work_performed_date(@from, @till)
    render :xml => { :params => {
        :from => @from,
        :till => @till },
      :orders => @orders
    }.to_xml( :root => :export, :include => {:order_activities => {:include => {:activity => {:except => :id}}, :except => [:order_id, :id, :activity_id]},
                  :order_spare_parts => {:include => {:spare_part => {}}, :except => [:order_id, :id, :updated_at]},
                  :customer => {}, :repair_type => {}},
                  :methods => [:activities_amount, :spare_parts_amount, :total_amount, :total_amount_with_discount],
        :except => [:created_at, :updated_at])
  end

  def organizations
    @organizations = Organization.order(:name)
    render(:xml => @organizations).to_xml(:root => :organizations)
  end

end
