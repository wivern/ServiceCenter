#encoding: UTF-8
class StatusController < ApplicationController
  respond_to :text
  def index
    begin
      order = Order.find_by_ticket(params[:ticket])
      if order
        render :text => order.status ? order.status.name : "Заказ принят"
      else
        render :text => "Заказ не найден"
      end
    rescue
      render :text => "Заказ не найден"
    end
  end
end
