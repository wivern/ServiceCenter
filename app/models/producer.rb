class Producer < ActiveRecord::Base
  validates_presence_of :name
  netzke_exclude_attributes :created_at, :updated_at
  has_many :products
  has_many :product_passports
  acts_as_mergeable
end
