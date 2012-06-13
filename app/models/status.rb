class Status < ActiveRecord::Base
  validates_presence_of :name
  netzke_exclude_attributes :created_at, :updated_at

  before_save :check_customer_info

  def status_name
    self.customer_info ? self.customer_info : self.name
  end

  private
  def check_customer_info
    self.customer_info = self.name unless self.customer_info
  end
end
