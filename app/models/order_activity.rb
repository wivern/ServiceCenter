class OrderActivity < ActiveRecord::Base
  belongs_to :activity
  belongs_to :order
end
