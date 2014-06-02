class HomeController < ApplicationController
  skip_before_action :authorize
  
  def index
    unless session[:user_id].nil?
      @user = User.find_by_id(session[:user_id])
      if @user.nil?
        reset_session
      end
    end
  end
  
end
