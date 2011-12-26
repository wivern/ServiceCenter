class Organization < ActiveRecord::Base
  has_many :persons
  netzke_exclude_attributes :created_at, :updated_at
end
