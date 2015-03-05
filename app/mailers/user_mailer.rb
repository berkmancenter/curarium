class UserMailer < ActionMailer::Base
  default from: 'curarium@metalab.harvard.edu'

  def welcome( user )
    @name = user.name
    mail to: user.email, subject: 'Welcome to the Curarium community!'
  end

  def personal_message(mail_params)
    @message = mail_params[:content]
    @url  = 'http://curarium.herokuapp.com'
    mail(to: mail_params[:receiver].email, subject: mail_params[:subject], from: mail_params[:sender].email)
  end
  
  def section_message(mail_params)
    @message = mail_params[:content]
    @url  = 'http://curarium.herokuapp.com'
    mail(to: mail_params[:sender].email, subject: mail_params[:subject], from: mail_params[:sender].email, cc: mail_params[:members])
  end
  
end
