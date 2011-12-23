class Report < ActiveRecord::Base
  has_and_belongs_to_many :repair_types
  netzke_exclude_attributes :created_at, :updated_at
end
