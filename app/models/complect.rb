class Complect < ActiveRecord::Base

  has_and_belongs_to_many :orders

  validates_presence_of :name
  netzke_exclude_attributes :created_at, :updated_at
end
