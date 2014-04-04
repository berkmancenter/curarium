class HomeController < ApplicationController
  skip_before_action :authorize
  
  def index
    unless session[:user_id].nil?
      @user = User.find(session[:user_id])
    end
  end
  
end
