class Customer < ActiveRecord::Base
  netzke_exclude_attributes :created_at, :updated_at
end
