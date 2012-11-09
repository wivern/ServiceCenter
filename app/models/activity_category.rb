class ActivityCategory < ActiveRecord::Base
  acts_as_nested_set
  has_many :activities
end
