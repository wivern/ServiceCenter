class ProductPassport < ActiveRecord::Base
  belongs_to :producer
  belongs_to :product
  belongs_to :dealer
  belongs_to :purchase_place

  attr_accessible :factory_number, :producer, :product, :dealer, :purchase_place,
                  :producer_id, :product_id

  validates_presence_of :factory_number, :producer, :product
end
