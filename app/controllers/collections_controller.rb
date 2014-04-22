class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:index, :show, :check_key, :ingest]
  skip_before_filter :verify_authenticity_token, only: [:check_key, :ingest]

  # GET /collections
  # GET /collections.json
  def index
    @collections = Collection.all
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    #right now, the ONE collection is showing ALL spotlights in Curarium. This has to change as soon as there are more than one collections.
    @spotlights = Spotlight.all
  end

  # GET /collections/new
  def new
    @collection = Collection.new
    @json_files = @collection.json_files.build
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
        params[:json_files]['path'].each do |url|
          @json_file = @collection.json_files.create!(path: url, collection_id: @collection.id)
        end
        Parser.new.async.perform(@collection.id)
        format.html { redirect_to @collection, notice: 'Collection was successfully created.' }
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
        params[:json_files]['path'].each do |url|
          @json_file = @collection.json_files.create!(path: url, collection_id: @collection.id)
        end
        Parser.new.async.perform(@collection.id)
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

  # ingestions
  
  def check_key
      collection = Collection.find_by(key: params[:collection_id])
      if collection.nil?
        render json: {collection: false }
      else
        render json: {collection: true }
      end
  end

  def ingest
    collection = Collection.find_by_key(params[:collection_id])
    configuration = collection.configuration
    properties = collection.properties.to_json
    properties = JSON.parse(properties)
    r = collection.records.new
    r.original = params["j"]
    r.save
    pr = {}
    pr['curarium'] = [r.id]
    configuration.each do |field|
      pr[field[0]] = Collection.follow_json(r.original, field[1])
      if pr[field[0]] == nil or ['thumbnail','image'].include?(field[0])
        next
      end
      pr[field[0]].each do |p|
        if(properties[field[0]][p] == nil)
          properties[field[0]][p] = 1
        else
          properties[field[0]][p] = properties[field[0]][p] + 1
         end
       end
    end
    collection.update(properties: properties)
    r.parsed = pr
    r.save
    render json: pr
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection
      @collection = Collection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      params.require(:collection).permit(:name, :description, :configuration, json_files_attributes: [:id, :collection_id, :path])
    end
end
