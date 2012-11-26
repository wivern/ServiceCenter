class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Person.new #guest user
    can :see, [:customer_in_order] #for everyone
    cannot :read, Price
    if user.has_role_inspector?
      can :manage, Order
      can :deliver, [:order_form, :orders]
      can :read, Price
      cannot :destroy, Order
    end
    if user.has_role_engineer?
      can :read, [SparePart, Activity]
      can :manage, Order
      cannot :destroy, Order
      can :deliver, [:orders, :part_component, :activity_component]
    end
    if user.has_role_manager?
      can :read, [Order, Report, Person]
      cannot :destroy, [Order, Price]
      cannot :manage, [Organization, Position, Currency, Report, PersonStatus]
      can :deliver, :all
      can :manage, :all
      cannot :read, Price
      cannot :deliver, [:organization_component, :position_component, :currency_component,
        :report_component, :person_status_component]
      can :merge, :all
      can :print, :payments
    end
    if user.has_role_analyst?
      can :read, Order
      can :deliver, :analytics
    end
    if user.has_role_price_reader?
      can :read, Price
    end
    if user.has_role_director?
      can :manage, :all
      cannot :manage, [Person, Report]
      can :read, [Person, Report]
      can :deliver, :all
      can :print, :payments
    end
    if user.has_role_administrator?
      can :manage, [Person, Organization, Position, Currency, Report, PersonStatus]
      can :deliver, [:person_component, :organization_component, :position_component, :currency_component,
        :report_component, :person_status_component]
      can :reset_password, Person
    end
  end
end
