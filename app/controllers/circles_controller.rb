class CirclesController < ApplicationController
  before_action :set_circle, only: [:show, :addcol, :edit, :update, :join, :leave, :destroy]

  # GET /circles
  def index
    response.headers[ 'Access-Control-Allow-Origin' ] = Waku::URL
    if authenticated?
      @circles = Circle.for_user @current_user
    else
      @circles = Circle.where privacy: 'public'
    end
  end

  # GET /circles/1
  def show
    redirect_to circles_path unless Circle.for_user( @current_user ).include? @circle
  end

  def addcol
    col = Collection.where( id: params[ :circle ][ :collections ] )
    @circle.collections << col
    @circle.save
    redirect_to @circle
  end

  # GET /circles/new
  def new
    if authenticated?
      @circle = Circle.new
    else
      render nothing: true, status: 401
    end
  end

  # GET /circles/1/edit
  def edit
  end

  # POST /circles
  def create
    @circle = Circle.new(circle_params)
    @circle.admin = @current_user

    if @circle.save
      redirect_to @circle, notice: 'Circle was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /circles/1
  def update
    if @circle.update(circle_params)
      #@circle.update( user_ids: ( [ @current_user.id ] + params[ :circle ][ :user_ids ] ) )
      redirect_to @circle, notice: 'Circle was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # PUT /circles/1
  def join
    @circle.users << @current_user unless @circle.users.include? @current_user
    redirect_to @circle
  end

  # PUT /circles/1
  def leave
    @circle.users.delete @current_user if @circle.users.include? @current_user
    redirect_to @circle
  end

  # DELETE /circles/1
  def destroy
    @circle.destroy
    redirect_to circles_url, notice: 'Circle was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_circle
      @circle = Circle.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def circle_params
      params.require(:circle).permit(:title, :description, :privacy, :collections_id, :user_ids => [])
    end
end
