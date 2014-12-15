class TraysController < ApplicationController
  before_action :set_tray, only: [:show, :edit, :update, :destroy, :add_works, :add_visualization, :external]
  skip_before_action :authorize, only: [:external]

  def index
    @owner = User.find( params[ :user_id ] || session[ :user_id ] )
    @trays = @owner.trays

    respond_to { |format|
      format.html {
        if request.xhr?
          @popup_action = params[ 'popup_action' ]
          @popup_action_item_id = params[ 'popup_action_item_id' ]
          render 'popup', layout: false
        else
          render
        end
      }
    }
  end
  
  def show
    @owner = User.find( params[ :user_id ] )
    @trays = @owner.trays
  end
  
  def add_works
    old_works = @tray.works
    request_works = params[:works]
    new_works = []
    request_works.each do |r|
      new_works.push(r.to_i)
    end
    @tray.works = (old_works+new_works).uniq
    @tray.save
    render json: @tray
  end
  
  def add_visualization
    visualizations = @tray.visualizations.clone
    visualizations.push(params[:viz_data])
    @tray.visualizations = visualizations
    render json: {result: @tray.save}
  end
  
  def new
    @tray = Tray.new
    if params.include? :section_id
      @owner = Section.find(params[:section_id])
    else
      @owner = User.find(params[:user_id])
    end
  end
    
  def create
    @owner = User.find( params[ :user_id ] )
    
    @tray = Tray.create(tray_params)

    if request.xhr?
      @trays = @owner.trays
      @popup_action = params[ 'popup_action' ]
      @popup_action_item_id = params[ 'popup_action_item_id' ]
      render 'popup', layout: false
    else
      redirect_to user_trays_path user: @owner
    end

  end
  
  def external #this is a provisional api like method for interacting with the WAKU editor.
    tray = {}
    tray[:name] =  @tray.name
    tray[:id] = @tray.id
    tray[:child_items] = [] #using the 'child_items' key to emulate the JDArchive and avoid potential conflicts with Waku as-built.
    @tray.works.each do |id|
      r = Work.find(id)
      r = r.parsed
      r.each do |key, value|
        r[key] = JSON.parse(value)
      end
      pr = {}
      pr[:id] = id
      pr[:uri] = r.images.first.image_url
      pr[:thumbnail_url] = r.images.first.thumbnail_url
      pr[:title] = r.title
      pr[:media_type] = "Image"
      pr[:layer_type] = "Image"
      pr[:archive] = ""
      pr[:media_geo_latitude] = 0
      pr[:media_geo_longitude] = 0
      tray[:child_items].push(pr)
    end
    render json: { items: [tray] } #again, conforming to the structure Waku is expecting from JDA
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tray
      @tray = Tray.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tray_params
      params.require(:tray).permit(:name, :owner_id, :owner_type) #, visualizations:[:url, terms:[:type,:property,:length]])
    end
  
end
