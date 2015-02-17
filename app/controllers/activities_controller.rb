class ActivitiesController < ApplicationController
  before_action :set_activitiable
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  # GET /activities
  def index
    @activities = @activitiable.activities
  end

  # GET /activities/1
  def show
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities
  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      redirect_to @activity, notice: 'Activity was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /activities/1
  def update
    if @activity.update(activity_params)
      redirect_to @activity, notice: 'Activity was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /activities/1
  def destroy
    @activity.destroy
    redirect_to activities_url, notice: 'Activity was successfully destroyed.'
  end

  private
    def set_activitiable
      if params[ :user_id ].present?
        @activitiable = User.friendly.find( params[ :user_id ] )
      elsif params[ :circle_id ].present?
        @activitiable = Circle.find( params[ :circle_id ] )
      else
        @activitiable = @current_user
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def activity_params
      params.require(:activity).permit(:user_id, :activity_type, :body)
    end
end
