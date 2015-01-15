class SessionsController < ApplicationController
  # POST /login
  def create
    if Rails.const_defined? 'Server' || Rails.env.test?
      # use test user on local dev server or while testing
      u = User.first
      login_browserid u.email 
      head :ok 
    else
      respond_to_browserid
    end
  end
  
  # POST /logout
  def destroy
    logout_browserid
    head :ok
  end
end
