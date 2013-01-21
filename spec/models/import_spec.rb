#encoding: UTF-8

require 'spec_helper'
require 'service_center/import/spare_parts'

describe ServiceCenter::Import::SpareParts do
  before(:all) do
    @open_solutions = FactoryGirl.create(:open_solutions)
    @dominion = FactoryGirl.create(:dominion)
  end

  after(:all) do
    @open_solution.destroy
    @dominion.destroy
  end

  describe "import" do
    it "do_test_import" do
      ServiceCenter::Import::SpareParts.do_import("/home/vitaly/Общедоступные/exch/unload2012-11-15.csv")
      spare_part = SparePart.find_by_part_number("F636-102-7410")
      spare_part.should_not be_nil
      spare_part.part_number.should == "F636-102-7410"
      spare_part.prices.for_organization(@open_solutions).value.should == 220
      spare_part.prices.for_organization(@dominion).value.should == 230
      #pending "import file"
    end
  end

end
