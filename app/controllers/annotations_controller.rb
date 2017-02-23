require 'base64'

class AnnotationsController < ApplicationController
  before_action :set_annotation, only: [:show, :edit, :update, :destroy]

  def index
    @work = Work.find(params[:work_id])
    @annotations = @work.annotations
    respond_to do |format|
      format.html { render }
      format.json {render json: @work.annotations}
    end
  end
  
  def new
    @annotation = Annotation.new
  end

  def show
    @popup_action = 'add'
    @popup_action_type = 'Annotation'
    @popup_action_item_id = @annotation.id

    @xhr = request.xhr?
    render template: 'annotations/show', layout: !@xhr
  end

  def edit
  end

  def create
    @work = Work.find(params[:work_id])
    @annotation = @work.annotations.new(annotation_params)
    @annotation.user_id = current_user.id
    respond_to do |format|
      if @annotation.save
        if params[ :annotation ][ :thumbnail_url ].present?
          begin
            thumbnail_base64 = params[ :annotation ][ :thumbnail_url ].split( ',' )[1]
            thumbnail_data = Base64.decode64 thumbnail_base64
            thumbnail_filename = "#{@annotation.id.to_s}.png"
            thumbnail_path = Curarium::ANNOTATION_THUMBNAILS_PATH.join thumbnail_filename
            File.open( thumbnail_path, 'wb' ) { |f|
              f.write thumbnail_data
            }
            @annotation.update_attributes thumbnail_url: "#{root_url}#{Curarium::ANNOTATION_THUMBNAILS_FOLDER}/#{thumbnail_filename}"
          rescue
            # ignore, not worth stopping the action for
          end
        end

        format.html { redirect_to @work, notice: 'Annotation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @annotation }
      else
        format.html { render action: 'new' }
        format.json { render json: @annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @annotation.delete
    redirect_to work_path( @work )
  end

  def update
    @work = Work.find(params[:work_id])
    @annotation.update(annotation_params)
    respond_to do |format|
      if @annotation.save
        format.html { redirect_to @work, notice: 'Annotation was successfully created.' }
        format.json { render action: 'show', status: :created, location: @annotation }
      else
        format.html { render action: 'new' }
        format.json { render json: @annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_annotation
      @work = Work.find params[ :work_id ]
      @annotation = Annotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def annotation_params
      params.require(:annotation).permit( :id, :title, :body, :x, :y, :width, :height, :image_url, :tags )
    end
  
end
