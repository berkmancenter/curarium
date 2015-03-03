class SpotlightsController < ApplicationController
  before_action :cors
  before_action :set_owners, only: [:create, :update, :destroy]
  before_action :set_spotlight, only: [:show, :edit, :update, :destroy]

  # GET /spotlights
  # GET /spotlights.json
  def index
    if authenticated?
      @spotlights = Spotlight.where "user_id = ? or privacy = 'public'", @current_user.id
    else
      @spotlights = Spotlight.where privacy: 'public'
    end
  end

  # GET /spotlights/1
  # GET /spotlights/1.json
  def show
  end

  # GET /spotlights/new
  def new
    redirect_to Waku::URL
  end

  # GET /spotlights/1/edit
  def edit
  end

  # POST /spotlights
  # POST /spotlights.json
  def create
    @spotlight = Spotlight.new(spotlight_params)
    @spotlight.user = @user
    @spotlight.circle = @circle

    respond_to { |format|
      if @spotlight.save
        format.json {
          render json: @spotlight.as_json, status: 200
        }
      else
        format.json {
          render json: {
            error: 500,
            reason: @spotlight.errors.values
          }.as_json, status: 500
        }
      end
    }
  end

  # PATCH/PUT /spotlights/1
  # PATCH/PUT /spotlights/1.json
  def update
    respond_to { |format|
      if @spotlight.update(spotlight_params)
        format.json {
          render json: @spotlight.as_json, status: 200
        }
      else
        format.json {
          render json: {
            error: 500,
            reason: @spotlight.errors.values
          }.as_json, status: 500
        }
      end
    }
  end

  # DELETE /spotlights/1
  # DELETE /spotlights/1.json
  def destroy
    respond_to { |format|
      @spotlight.destroy

      format.json {
        render nothing: true, status: 204
      }
      format.html {
        render :index
      }
    }
  end

  private
    def cors
      response.headers[ 'Access-Control-Allow-Origin' ] = Waku::URL
    end

    def set_owners
      @user = User.friendly.find params[:user_id] unless params[ :user_id ].nil?
      @circle = Circle.for_user( @user ).find( params[:circle_id] ) unless (@user.nil? || params[ :circle_id ].nil?)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_spotlight
      if @circle.present?
        @spotlight = @circle.spotlights.friendly.find params[:id].to_s
      elsif @user.present?
        @spotlight = @user.spotlights.friendly.find params[:id].to_s
      else
        @spotlight = Spotlight.friendly.find params[:id].to_s
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spotlight_params
      params.require(:spotlight).permit(:title, :privacy, :body, :waku_id, :waku_url)
    end
end
