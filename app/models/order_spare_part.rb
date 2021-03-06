class OrderSparePart < ActiveRecord::Base
  belongs_to :order
  belongs_to :spare_part
  belongs_to :currency
  #validates_presence_of :spare_part

  before_create :checkout_price

  def amount
    if quantity and price
      quantity * price
    else
      0
    end
  end

  protected
  def checkout_price
    if spare_part
      write_attribute(:price, spare_part.price.value)
      write_attribute(:currency, spare_part.price.currency)
    end
  end
end
