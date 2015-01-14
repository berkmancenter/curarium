class SessionsController < ApplicationController
  # POST /login
  def create
    if Rails.const_defined? 'Server'
      # use test user on local dev server
      u = User.first
      login_browserid u.email 
      session[ :user_id ] = u.id
      head :ok 
    else
      respond_to_browserid
      email = session[browserid_config.session_variable]
      if email.present?
        u = User.find_or_create_by_email email
        session[ :user_id ] = u.id
      end
    end
  end
  
  # POST /logout
  def destroy
    logout_browserid
    session[ :user_id ] = nil
    head :ok
  end
end
