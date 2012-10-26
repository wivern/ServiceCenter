class Activity < ActiveRecord::Base
  netzke_exclude_attributes :created_at, :updated_at
  validates_presence_of :code, :name

  acts_as_mergeable
  acts_as_priceable

end
