class HomeController < ApplicationController
  def index
    @works = Work.with_thumb.limit(25).order("RANDOM()")
    @collection = Collection.with_works.where(approved: true).limit(1).order("RANDOM()").first
    @spotlights = Spotlight.user_only.where( privacy: 'public' ).limit(25).order("RANDOM()")
    @all = (@works+@spotlights).shuffle
  end
  
  def about
    @work = Work.limit(1).order("RANDOM()").first
    while @work.images.none?
      @work = Work.limit(1).order("RANDOM()").first
    end
  end

  def bot
  end
end
