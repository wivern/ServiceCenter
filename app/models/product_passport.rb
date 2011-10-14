class ProductPassport < ActiveRecord::Base
  belongs_to :producer
  belongs_to :product_name
  belongs_to :dealer

  attr_accessible :factory_number

  validates_presence_of :factory_number, :producer, :product_name
end
