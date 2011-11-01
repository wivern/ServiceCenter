class WelcomeController < ApplicationController
  before_filter :authenticate_person!

  def index
  end

end
