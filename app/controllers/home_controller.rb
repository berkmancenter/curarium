class HomeController < ApplicationController
  skip_before_action :authorize
  
  def index
    @works = Work.limit(10).order("RANDOM()")
    @collection = Collection.where(approved: true).limit(1).order("RANDOM()").first
    @spotlights = Spotlight.limit(10).order("RANDOM()")
    @all = (@works+@spotlights).shuffle
    unless session[:user_id].nil?
      @user = User.find_by_id(session[:user_id])
      if @user.nil?
        reset_session
      end
    end
    
  end
  
  def about
    @work = Work.limit(1).order("RANDOM()").first
    while(@work.parsed['image'].nil?)
      @work = Work.limit(1).order("RANDOM()").first
    end
  end

end
