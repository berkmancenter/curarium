require 'zip'

class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :configure, :add_field, :update, :destroy]

  # GET /collections
  # GET /collections.json
  def index
    @collections = Collection.where approved: true
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    #right now, the ONE collection is showing ALL spotlights in Curarium. This has to change as soon as there are more than one collections.
    #@spotlights = Spotlight.all 
    @work =@collection.works.with_thumb.limit(1).order("RANDOM()").first
    works = @collection.works.with_thumb.limit(12).order("RANDOM()")
    spotlights = Spotlight.limit(6).order("RANDOM()")
    @all = (works).shuffle
    #@all = (works+spotlights).shuffle #for the time being we are removing spotlights from works - adding which messes up page layout
  end

  # GET /collections/new
  def new
    @collection = Collection.new
    @collection.approved = true
  end

  # GET /collections/1/edit
  def edit
  end
  
  # GET /collections/1
  def configure
    @sample_work = @collection.works.first if @collection.works.any?

    @collection_fields = CollectionField.where( "NOT name IN ('#{@collection.configuration.keys.join( "','" )}')" )
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = Collection.new collection_params
    @collection.admins << @current_user

    if @collection.save
      Zip::File.open( params[:collection][:file].path ) { |zip_file|
        collection_path = Rails.root.join 'db', 'collection_data', @collection.id.to_s
        FileUtils.rm_rf collection_path

        zip_file.each { |entry| 
          json_file_path = collection_path.join entry.name
          entry.extract json_file_path

          if json_file_path.to_s.downcase =~ /\.json/ && !json_file_path.to_s.include?( '__MACOSX' )
            @collection.works.create original: IO.read( json_file_path )
            #ImportWork.perform_async @collection.id, @collection.configuration, json_file_path.to_s
          end
        }
      }
      redirect_to configure_collection_path( @collection )
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    respond_to do |format|
      if @collection.update(collection_params)
#        f = File.new("#{Rails.root}/tmp/#{params[:file].original_filename}", 'wb')
#        f.write params[:file].read
#        f.close
#        Parser.new.async.perform(@collection.id, "#{Rails.root}/tmp/#{params[:file].original_filename}")
        format.html {
          if request.xhr?
            if collection_params[ :configuration ].present?
              render partial: 'collections/form_active_fields'
            else
              render @collection
            end
          else
            redirect_to @collection, notice: 'Collection was successfully updated.'
          end
        }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /collections/1/add_field
  # xhr
  def add_field
    collection_field = params[ :collection_field ]
    config = @collection.configuration
    config[ collection_field ] = '[]'
    if @collection.update configuration: config
      render partial: 'collections/form_active_fields'
    else
      render partial: 'collections/form_active_fields'
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to collections_url }
      format.json { head :no_content }
    end
  end

  # importations
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection
      @collection = Collection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      params.require(:collection).permit(:name, :description, :configuration, :source, :approved, :cover_id)
    end
end
