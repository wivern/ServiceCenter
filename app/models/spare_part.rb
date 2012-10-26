class SparePart < ActiveRecord::Base
  acts_as_priceable

  validates_presence_of :name, :part_number
  validates_uniqueness_of :part_number

  netzke_exclude_attributes :created_at, :updated_at
end
