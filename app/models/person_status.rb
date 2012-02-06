class PersonStatus < ActiveRecord::Base
  netzke_exclude_attributes :created_at, :updated_at
  validates_presence_of :name

  scope :not_fired, where('prevent_sign_in = false or prevent_sign_in is null')
end
