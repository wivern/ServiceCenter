class OrderLocation < ActiveRecord::Base
  set_table_name "locations"
  validates_presence_of :name
  netzke_exclude_attributes :created_at, :updated_at
  acts_as_mergeable
end
