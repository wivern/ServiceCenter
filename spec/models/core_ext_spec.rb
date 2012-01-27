require 'spec_helper'
require 'core_ext'

describe Symbol do
  it "converts symbol to icons uri" do
    :add.icon.should eq("/images/icons/add.png")
  end
end