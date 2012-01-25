class Currency < ActiveRecord::Base
  validates_presence_of :name, :full_name, :char_code, :num_code
  netzke_exclude_attributes :created_at, :updated_at
end
