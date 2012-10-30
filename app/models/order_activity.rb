class OrderActivity < ActiveRecord::Base
  belongs_to :activity
  belongs_to :order

  def price
    if order.organization
      logger.debug "Activity: #{activity.inspect}"
      activity.prices.for_organization(order.organization).value
    else
      0
    end
  end

end
