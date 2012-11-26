require 'spec_helper'
require "cancan/matchers"

describe Ability do
  describe "as an inspector user" do
    before(:each) do
      @user = @user || FactoryGirl.create(:inspector_person)
      @ability = Ability.new @user
    end

    it "should manage orders" do
      @ability.should be_able_to(:manage, Order)
    end

    it "should read prices" do
      @ability.should be_able_to(:read, Price)
    end

    it "should not destroy Order" do
      @ability.should_not be_able_to(:destroy, Order)
    end

  end

  describe "as a brigadir user" do
    before(:each) do
      @user = @user || FactoryGirl.create(:brigadir_person)
      @ability = Ability.new @user
    end

    it "should not read prices" do
      @ability.should_not be_able_to(:read, Price)
    end
    it "should read person" do
      @ability.should be_able_to(:read, Person)
    end
  end

end