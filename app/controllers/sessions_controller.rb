class SessionsController < ApplicationController
  skip_before_action :authorize
  
  # POST /login
  def create
    respond_to_browser_id
  end
  
  # POST /logout
  def destroy
    logout_browser_id
    head :ok
  end
end
