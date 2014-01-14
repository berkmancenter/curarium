module UsersHelper
  
  def owner?
    return @user.id == session[:user_id] || User.find(session[:user_id]).super
  end
  
end
