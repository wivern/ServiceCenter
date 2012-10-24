class Activity < ActiveRecord::Base
  netzke_exclude_attributes :created_at, :updated_at
  validates_presence_of :code, :name
  #belongs_to :currency
  has_one :price, :as => :priceable,
           :conditions => proc{["prices.organization_id = ?", Netzke::Core.current_user.organization]}

  acts_as_mergeable

  #temp stub
  def price_id
    self.price.object_id
  end
end
