class Organization < ActiveRecord::Base
  has_many :persons
  belongs_to :responsible, :class_name => "Person"
  netzke_exclude_attributes :created_at, :updated_at
end
