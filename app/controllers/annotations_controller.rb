class AnnotationsController < ApplicationController
  def new
    @annotation = Annotation.new
  end

  def show
  end

  def edit
  end

  def create
    @record = Record.find(params[:record_id])
    @annotation = Annotation.new
    @annotation.user_id = session[:user_id]
    @annotation.record_id = params[:record_id]
    @annotation.content = params[:content]
    respond_to do |format|
      if @annotation.save
        format.html { redirect_to @record, notice: 'Annoation was successfully created.' }
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
  end

  def index
    @record = Record.find(params[:record_id])
    respond_to do |format|
      format.html {redirect_to @record }
      format.json {render json: @record.annotations}
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_annotation
      @annotation = Annotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def annotation_params
      params.require(:annotation).permit(:content)
    end
  
end
