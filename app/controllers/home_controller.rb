class HomeController < ApplicationController
  skip_before_action :authorize
  
  def index
    
  end
  
end
