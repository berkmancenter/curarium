class CirclesController < ApplicationController
  before_action :set_circle, only: [:show, :edit, :update, :destroy]

  # GET /circles
  def index
    @circles = Circle.all
  end

  # GET /circles/1
  def show
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
      redirect_to @circle, notice: 'Circle was successfully updated.'
    else
      render action: 'edit'
    end
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
      params.require(:circle).permit(:title, :description, :users_id, :collections_id)
    end
end
