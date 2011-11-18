class ProductPassport < ActiveRecord::Base
  belongs_to :producer
  belongs_to :product
  belongs_to :dealer
  belongs_to :purchase_place

  attr_accessible :factory_number

  validates_presence_of :factory_number, :producer, :product
end
