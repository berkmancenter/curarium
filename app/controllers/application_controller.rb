class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize
  
  def treemapify(data,name='main')
    branch = {}
    branch['name'] = name
    if(data.class == Array || data.class == Hash)
      branch['children'] = []
      data.each do |child|
        branch['children'].push(treemapify(child[1],child[0]))
      end
    else
      branch['size'] = data
      return branch
    end
    return branch
  end
  
  private
  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "Please log in"
    end
  end
end
