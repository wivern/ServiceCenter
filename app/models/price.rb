class Price < ActiveRecord::Base
  belongs_to :priceable, :polymorphic => true
  belongs_to :currency
  belongs_to :organization

  before_create :update_organization
  validates_presence_of :priceable, :organization

  protected
  def update_organization
    current_user = Netzke::Core.current_user
    self.organization = current_user.organization if current_user
  end
end
