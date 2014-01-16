class UserMailer < ActionMailer::Base
  default from: "do-not-reply@curarium.com"
  
  def personal_message(params)
    @message = params[:content]
    @url  = 'http://curarium.herokuapp.com'
    mail(to: params[:receiver].email, subject: params[:subject], from: params[:sender].email)
  end
  
end
