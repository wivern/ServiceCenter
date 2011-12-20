class OrderSparePart < ActiveRecord::Base
  belongs_to :order
  belongs_to :spare_part
  belongs_to :currency
  validates_presence_of :order, :spare_part

  before_create :checkout_price

  protected
  def checkout_price
    if spare_part
      write_attribute(:price, spare_part.price)
      write_attribute(:currency, spare_part.currency)
    end
  end
end
