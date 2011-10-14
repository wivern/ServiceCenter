class Complect < ActiveRecord::Base
  validates_presence_of :name
  netzke_exclude_attributes :created_at, :updated_at
end
