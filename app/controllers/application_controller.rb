class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize
  before_action :set_active_collection
  
  private
  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "Please log in"
    end
  end
  
  def set_active_collection
    unless cookies[:active_collection].nil?
      @active_collection = Collection.find(cookies[:active_collection])
    end
  end
  
end
