class Product < ActiveRecord::Base
  belongs_to :producer

  validates_presence_of :name, :producer
  netzke_exclude_attributes :created_at, :updated_at
end