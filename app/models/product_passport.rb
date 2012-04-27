class ProductPassport < ActiveRecord::Base
  belongs_to :producer
  belongs_to :product
  belongs_to :dealer
  belongs_to :purchase_place

  attr_accessible :factory_number, :product, :producer, :dealer, :purchase_place,
                  :product_id, :producer_id, :purchase_place_id, :guarantee_stub_number,
                  :purchased_at

  validates_presence_of :factory_number, :product, :producer

  def purchased_at_str
    s = purchased_at.to_datetime.strftime('%d.%m.%Y') if purchased_at
    s ||= ""
    s
  end
end
