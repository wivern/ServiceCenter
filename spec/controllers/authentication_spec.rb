require 'spec_helper'

describe WelcomeController do
  include Devise::TestHelpers

  it "should authenticate" do
    @member = Factory.create :person
    sign_in @member
  end

end