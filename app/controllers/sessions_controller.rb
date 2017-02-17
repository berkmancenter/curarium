class SessionsController < ApplicationController
  # POST /login
  # creates User object if one desn't exist for email
  def create
    if Rails.const_defined?( 'Server' ) || Rails.env.test?
      # use test user on local dev server or while testing
      u = User.first
      login_browserid u.email 
      head :ok 
    else
      respond_to_browserid
      u = User.where email: browserid_email
      if u.empty?
        u = User.create email: browserid_email, name: browserid_email.split( '@' ).first
        UserMailer.welcome( u ).deliver
      end
    end
  end
  
  # GET /logout
  def destroy
    sign_out @current_user
    redirect_to root_path
  end
end
