class SessionsController < ApplicationController
  # POST /login
  # creates User object if one desn't exist for email
  def create
    if Rails.const_defined? 'Server' || Rails.env.test?
      # use test user on local dev server or while testing
      u = User.first
      login_browserid u.email 
      head :ok 
    else
      respond_to_browserid
      User.find_or_create_by_email browserid_email
    end
  end
  
  # POST /logout
  def destroy
    logout_browserid
    head :ok
  end
end
