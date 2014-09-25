class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:index, :show, :import]

  # GET /collections
  # GET /collections.json
  def index
    @collections = Collection.all
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    #right now, the ONE collection is showing ALL spotlights in Curarium. This has to change as soon as there are more than one collections.
    #@spotlights = Spotlight.all 
    @record =@collection.records.limit(1).order("RANDOM()").first
    records = @collection.records.limit(6).order("RANDOM()")
    spotlights = Spotlight.limit(6).order("RANDOM()")
    @all = (records).shuffle
    #@all = (records+spotlights).shuffle #for the time being we are removing spotlights from records - adding which messes up page layout
  end

  # GET /collections/new
  def new
    @collection = Collection.new
  end

  # GET /collections/1/edit
  def edit
    @json_files = @collection.json_files.build
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = Collection.new(collection_params)
    @collection.approved = false
    @collection.admin = [session[:user_id]]
    respond_to do |format|
      if @collection.save
        f = File.new("#{Rails.root}/tmp/#{params[:file].original_filename}", 'wb')
        f.write params[:file].read
        f.close
        Parser.new.async.perform(@collection.id, "#{Rails.root}/tmp/#{params[:file].original_filename}")
        #Parser.new.async.perform(@collection.id)
        format.html { redirect_to collections_path, notice: 'Your collection is currently uploading, please check back within the hour.' }
        format.json { render action: 'show', status: :created, location: @collection }
      else
        format.html { render action: 'new' }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    respond_to do |format|
      if @collection.update(collection_params)
        f = File.new("#{Rails.root}/tmp/#{params[:file].original_filename}", 'wb')
        f.write params[:file].read
        f.close
        Parser.new.async.perform(@collection.id, "#{Rails.root}/tmp/#{params[:file].original_filename}")
        format.html { redirect_to @collection, notice: 'Collection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
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
      params.require(:collection).permit(:name, :description, :configuration, :source)
    end
end
