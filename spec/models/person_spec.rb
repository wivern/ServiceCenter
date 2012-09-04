require 'spec_helper'

describe Person do
  before(:each) do
    @person = create(:person)
    @order = create(:order)
  end

  it "should has organization" do
    @person.organization.should_not nil
  end

  it "should has completed order with 10 activities" do
    order = create :performed_order, activities_count: 10
    order.activities.count.should eql(10)
    order.status.performed.should eql(true)
  end

  it "should has 3 completed orders" do
    create_list :performed_order, 3, engineer: @person
    @person.performed_orders.count.should eql(3)
  end

  it "should has score of 150 pts" do
    create_list :performed_order, 3, activities_count: 5, engineer: @person
    @person.scored_at(Date.today).should eql(150)
  end

end
