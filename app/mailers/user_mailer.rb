class UserMailer < ActionMailer::Base
  default from: "do-not-reply@curarium.com"
  
  def personal_message(mail_params)
    @message = mail_params[:content]
    @url  = 'http://curarium.herokuapp.com'
    mail(to: mail_params[:receiver].email, subject: mail_params[:subject], from: mail_params[:sender].email)
  end
  
  def section_message(mail_params)
    @message = mail_params[:content]
    @url  = 'http://curarium.herokuapp.com'
    mail(to: mail_params[:sender].email, subject: mail_params[:subject], from: mail_params[:sender].email, cc.mail_params[:members])
  end
  
end
