class SparePart < ActiveRecord::Base
  #belongs_to :currency
  has_one :price, :as => :priceable,
           :conditions => proc{["prices.organization_id = ?", Netzke::Core.current_user.organization]}

  validates_presence_of :name, :part_number
  validates_uniqueness_of :part_number

  netzke_exclude_attributes :created_at, :updated_at

  def price_id
    self.price.object_id
  end
end
