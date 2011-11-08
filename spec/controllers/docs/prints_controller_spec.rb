require 'spec_helper'

describe Docs::PrintsController do

  describe "GET 'print'" do
    it "should be successful" do
      get 'print'
      response.should be_success
    end
  end

end
