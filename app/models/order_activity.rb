class OrderActivity < ActiveRecord::Base
  belongs_to :activity
  belongs_to :order
  belongs_to :currency
  before_create :update_price

protected
  def update_price
    if activity
      write_attribute(:price, activity.price.value)
      write_attribute(:currency, activity.price.currency)
    end
  end

end
