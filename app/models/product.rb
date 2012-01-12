class Product < ActiveRecord::Base
  belongs_to :producer
  has_many :product_passports

  validates_presence_of :name, :producer
  netzke_exclude_attributes :created_at, :updated_at
  acts_as_mergeable
end
