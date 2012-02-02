class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Person.new #guest user
    if user.has_role_inspector?
      #can :read, Report
      can :manage, Order
      can :deliver, [:order_form, :orders]
      cannot :destroy, Order
    end
    if user.has_role_engineer?
      can :read, [SparePart, Activity]
      can :manage, Order
      cannot :destroy, Order
      can :deliver, [:orders, :part_component, :activity_component]
    end
    if user.has_role_manager?
      can :read, [Order, Report]
      can :manage, :all
      cannot :destroy, [Order]
      cannot :manage, [Person, Organization, Position, Currency, Report, PersonStatus]
      can :deliver, :all
      cannot :deliver, [:order_form, :person_component, :organization_component, :position_component, :currency_component,
        :report_component, :person_status_component]
      can :merge, :all
    end
    if user.has_role_director?
      can :manage, :all
      cannot :manage, [Person, Report]
      can :read, [Person, Report]
    end
    if user.has_role_administrator?
      can :manage, [Person, Organization, Position, Currency, Report, PersonStatus]
      can :deliver, [:person_component, :organization_component, :position_component, :currency_component,
        :report_component, :person_status_component]
      can :reset_password, Person
    end
  end
end
