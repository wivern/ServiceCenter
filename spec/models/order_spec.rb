require 'spec_helper'

describe Order do

  it "should has 5 completed orders by scope" do
    create_list :performed_order, 5
    Order.maintenance_finished.count.should eql(5)
  end

  it "should has completed order with score of 50" do
    order = create :performed_order, activities_count: 5
    order.activities_score.should eql(50)
  end
end
