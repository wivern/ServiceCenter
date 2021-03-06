#encoding: UTF-8
class Order < ActiveRecord::Base
  belongs_to :reason          #Основание диагностики
  belongs_to :diag_manager, :class_name => "Person"
  belongs_to :customer
  belongs_to :manager, :class_name => "Person"
  belongs_to :repair_type
  belongs_to :engineer, :class_name => "Person"   #Сервис-инженер проводивший ремонт
  belongs_to :status
  belongs_to :deliver_manager, :class_name => "Person"
  belongs_to :product_passport, :autosave => true
  belongs_to :organization
  belongs_to :diagnostic_activity, :class_name => "Activity",
      :conditions => "diagnostic = true"
  has_and_belongs_to_many :complects
  has_and_belongs_to_many :external_states
  has_and_belongs_to_many :defects
  has_and_belongs_to_many :internal_states
  has_and_belongs_to_many :grounds
  has_and_belongs_to_many :goals
  has_many :order_activities
  has_many :working_order_activities, :include => :activity, :class_name => "OrderActivity",
           :conditions => "activities.diagnostic = 'f'"
  has_many :activities, :through => :order_activities
  has_many :working_activities, :source => :activity, :through => :order_activities,
           :conditions => "activities.diagnostic = 'f'"
  has_many :order_spare_parts
  has_many :spare_parts, :through => :order_spare_parts

  has_one :product, :through => :product_passport
  has_one :producer, :through => :product_passport
  belongs_to :order_location, :foreign_key => "location_id"

  belongs_to :created_from, :class_name => "Order"
  has_many :inherited, :class_name => "Order", :foreign_key => :created_from_id

  before_create :update_number_and_ticket
  before_create :update_organization

  netzke_exclude_attributes :created_at, :updated_at

  accepts_nested_attributes_for :customer, :reason, :product_passport, :engineer
  validates_presence_of :repair_type, :customer, :product_passport, :complects, :external_states, :on => :create

  scope :by_organization, lambda{
    where("Orders.organization_id = ?", Netzke::Core.current_user.organization)
  }

  scope :inherited_from, lambda{|order|
    where("created_from_id = ?", order.id)
  }

  scope :order_by_product, lambda{|dir|
     includes(:product).order("products.name #{dir.to_s}")
  }

  scope :order_by_producer, lambda{|dir|
      includes(:producer).order("producers.name #{dir.to_s}")
  }

  scope :completed, includes(:status).where("statuses.complete = true")
  scope :ready, includes(:status).where("statuses.ready = true")
  scope :maintenance_finished, includes(:status).where("statuses.performed = true")
  scope :performed, lambda{ ready | completed } # where(:repair_type_id => [1,3]) #TODO change to repair type property
  scope :by_work_performed_date, lambda{ |start, till|
    where("work_performed_at between ? and ?", start, till) }
  scope :by_deliver_date, lambda{|start, till|
    where("actual_deliver_at between ? and ?", start, till)}

  cattr_accessor :discount_types
  @@discount_types = {
      :disabled => "Нет скидки",
      :percent  => "Процент",
      :amount   => "Сумма"
  }

  def self.completed_by_date_and_organization(from, till, organization = nil)
    if organization.present?
      logger.debug "Filter by organization"
      orders = (Order.performed.completed.by_deliver_date(from, till) + Order.ready.by_work_performed_date(from, till)).where(:organization => organization) if organization.present?
    else
      logger.debug "Export orders from #{from} till #{till}"
      orders = Order.performed.completed.by_deliver_date(from, till) + Order.ready.by_work_performed_date(from, till)
    end if
    orders
  end

  def activities_amount
    working_order_activities.inject(0){|sum, a| sum + a.price}
  end

  def activities_score
    activities.inject(0){|sum, a| sum + a.score}
  end

  def activities_count
    activities.size
  end

  def discount_amount
    logger.debug "Discount\nType: #{discount_type}, value: #{discount}"
    amount = case discount_type.to_sym
      when :amount
        discount
      when :percent
        total_amount * discount / 100
      else
        0
    end if discount_type
    amount ||= 0
    logger.debug "Amount: #{amount}"
    amount
  end

  def producer_id
    if producer
      producer.id
    else
      0
    end
  end

  def total_amount_with_discount
    total_amount - discount_amount
  end

  def spare_parts_amount
    order_spare_parts.inject(0){|sum, sp| sum + sp.amount}
  end

  def spare_parts_count
    order_spare_parts.size
  end

  def total_amount
    activities_amount + spare_parts_amount
  end

  def complect
    collection_printable :complects
  end

  def diag_goal
    collection_printable(:goals)
  end

  def defect
    collection_printable(:defects)
  end

  def external_state
    collection_printable(:external_states)
  end

  def internal_state
    collection_printable(:internal_states)
  end

  def activities_printable
    collection_printable(:activities)
  end

  def spare_parts_printable
    collection_printable :spare_parts, :part_number
  end

  def product_id
    if product
      product.id
    else
      0
    end
  end

  private

  def collection_printable(association, attribute = :name, separator = ', ')
    self.send(association.to_sym).map{|i| i.send(attribute.to_sym)}.join(separator)
  end

  def update_number_and_ticket
    self.number = Numerator.next_number(:number, self)
    self.ticket = Numerator.next_number(:ticket)
  end

  def update_organization
    current_user = Netzke::Core.current_user
    self.organization = current_user.organization if current_user
  end
end
