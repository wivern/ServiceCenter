class Activity < ActiveRecord::Base
  netzke_exclude_attributes :created_at, :updated_at
  validates_presence_of :name
  belongs_to :currency
end
