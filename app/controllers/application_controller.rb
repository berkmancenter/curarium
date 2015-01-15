class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :load_user
  before_action :set_active_collection
  
  private

  def set_active_collection
    unless cookies[:active_collection].nil?
      @active_collection = Collection.find(cookies[:active_collection])
    end
  end
  
  def load_user
    current_user
  end
end
