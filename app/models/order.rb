class Order < ActiveRecord::Base
  belongs_to :external_state
  belongs_to :internal_state
  belongs_to :reason          #Основание диагностики
  belongs_to :goal            #Цель диагностики
  belongs_to :diag_manager, :class_name => "Person"
  belongs_to :customer
  belongs_to :manager, :class_name => "Person"
  belongs_to :repair_type
  belongs_to :complect
  belongs_to :engineer, :class_name => "Person"   #Сервис-инженер проводивший ремонт
  belongs_to :status
  belongs_to :deliver_manager, :class_name => "Person"
  belongs_to :product_passport, :autosave => true
  belongs_to :result

  before_create :update_number_and_ticket

  netzke_exclude_attributes :created_at, :updated_at

  accepts_nested_attributes_for :customer, :reason, :external_state, :internal_state, :product_passport
  validates_presence_of :repair_type, :customer, :product_passport

  private

  def update_number_and_ticket
    self.number = Numerator.next_number(:number, self)
    self.ticket = Numerator.next_number(:ticket)
  end
end
