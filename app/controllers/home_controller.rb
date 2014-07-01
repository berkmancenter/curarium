class HomeController < ApplicationController
  skip_before_action :authorize
  
  def index
    @records = Record.limit(10).order("RANDOM()")
    @collection = Collection.where(approved: true).limit(1).order("RANDOM()").first
    @spotlights = Spotlight.limit(10).order("RANDOM()")
    @all = (@records+@spotlights).shuffle
    unless session[:user_id].nil?
      @user = User.find_by_id(session[:user_id])
      if @user.nil?
        reset_session
      end
    end
    
  end
  
  def about
    @record = Record.limit(1).order("RANDOM()").first
    while(@record.parsed['image'].nil?)
      @record = Record.limit(1).order("RANDOM()").first
    end
  end

end
