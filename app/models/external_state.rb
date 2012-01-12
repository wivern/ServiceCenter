class ExternalState < ActiveRecord::Base
  validates_presence_of :name
  netzke_exclude_attributes :created_at, :updated_at
  has_and_belongs_to_many :orders
  acts_as_mergeable
end
