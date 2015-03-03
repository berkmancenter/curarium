class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :load_user
  before_action :set_active_collection, :load_header_collections
  
  private

  def set_active_collection
    unless cookies[:active_collection].nil?
      @active_collection = Collection.find(cookies[:active_collection])
    end
  end

  def load_header_collections
    @header_collections = Collection.where approved: true
  end
  
  def load_user
    current_user

    if @current_user.nil? && params[ :user_id ].present? && request.format == :json #&& request.xhr?
      login_browserid User.friendly.find( params[ :user_id ] ).email
      current_user
    end
  end
end
