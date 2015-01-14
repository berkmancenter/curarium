class AnnotationsController < ApplicationController
  before_action :set_annotation, only: [:show, :edit, :update, :destroy]

  def new
    @annotation = Annotation.new
  end

  def show
    respond_to do |format|
       format.html { }
       format.json { }
       format.js { render action: "show" }
     end
  end

  def edit
  end

  def create
    @work = Work.find(params[:work_id])
    @annotation = @work.annotations.new(annotation_params)
    @annotation.user_id = session[:user_id]
    respond_to do |format|
      if @annotation.save
        format.html { redirect_to @work, notice: 'Annoation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @annotation }
      else
        format.html { render action: 'new' }
        format.json { render json: @annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  def update
    @work = Work.find(params[:work_id])
    @annotation.update(annotation_params)
    respond_to do |format|
      if @annotation.save
        format.html { redirect_to @work, notice: 'Annoation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @annotation }
      else
        format.html { render action: 'new' }
        format.json { render json: @annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @work = Work.find(params[:work_id])
    respond_to do |format|
      format.html {redirect_to @work }
      format.json {render json: @work.annotations}
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_annotation
      @annotation = Annotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def annotation_params
      params.require(:annotation).permit( :id, :work_id, :user_id, :title, :body, :x, :y, :width, :height, :image_url, :tags )
    end
  
end
