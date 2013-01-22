#encoding: UTF-8

require 'spec_helper'
require 'service_center/import/spare_parts'
require "rspec/expectations"

describe ServiceCenter::Import::SpareParts do

  before(:all) do
    Organization.delete_all
    @open_solutions = FactoryGirl.create(:open_solutions)
    @dominion = FactoryGirl.create(:dominion)
  end

  after(:all) do
    Organization.delete_all
  end

  describe "import" do
    it "do_test_import" do
      ServiceCenter::Import::SpareParts.do_import("#{Rails.root}/spec/import/unload.csv")
      spare_part = SparePart.find_by_part_number("F636-102-7410")
      spare_part.should_not be_nil
      spare_part.part_number.should == "F636-102-7410"
      spare_part.prices.for_organization(@open_solutions).value.should == 220
      spare_part.prices.for_organization(@dominion).value.should == 230
      #pending "import file"
    end
    it "update existing prices" do
      # prepare prices to update
      SparePart.delete_all
      Price.delete_all
      spare_part = FactoryGirl.create(:spare_part1)
      FactoryGirl.create(:price1_1, priceable: spare_part, organization: @open_solutions)
      FactoryGirl.create(:price1_2, priceable: spare_part, organization: @dominion)
      spare_part.should_not be_nil
      spare_part.prices.for_organization(@open_solutions).value.should == 200
      ## do import
      ServiceCenter::Import::SpareParts.do_import("#{Rails.root}/spec/import/unload.csv")
      ## Now prices have to be updated from file
      spare_part.prices.for_organization(@open_solutions).value.should == 220
      spare_part.prices.for_organization(@dominion).value.should == 230
    end
    it "one update and one create" do
      SparePart.delete_all
      Price.delete_all
      spare_part = FactoryGirl.create(:spare_part1)
      FactoryGirl.create(:price1_1, priceable: spare_part, organization: @open_solutions)
      spare_part.prices.for_organization(@open_solutions).value.should == 200
      ServiceCenter::Import::SpareParts.do_import("#{Rails.root}/spec/import/unload.csv")
      spare_part.prices.for_organization(@open_solutions).value.should == 220
      spare_part.prices.for_organization(@dominion).value.should == 230
    end
  end

end
