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
  end

  # GET /collections/new
  def new
    @collection = Collection.new
  end

  # GET /collections/1/edit
  def edit
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = Collection.new(collection_params)
    @collection.approved = false
    @collection.admin = [session[:user_id]]
    respond_to do |format|
      if @collection.save
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
    r = collection.records.new
    r.original = params["j"]
    r.save
    pr = {}
    pr['curarium'] = [r.id]
    configuration.each do |field|
      pr[field[0]] = collection.follow_json(r.original, field[1])
    end
    r.parsed = pr
    r.save
    render json: pr
  end
  
  #VISUALIZATIONS
  
  def tag
    @collection = Collection.find(params[:collection_id])
    jason = @collection.properties(params[:include],params[:property])
    render json: jason
  end
  
  def treemap
    @collection = Collection.find(params[:collection_id])
    jason = treemapify(@collection.properties(params[:include],params[:property]))
    render json: jason
  end
  
  def collection_data
    collection = Collection.find(params[:collection_id])
    @data = {}
    @data[:configuration] = collection.recordconfig.configuration
    @data[:spotlights] = collection.spotlights
    @data[:spotlights].each do |s|
      s['url'] = spotlight_url(s['id'])
    end
    @data[:description] = collection.desc
    @data[:id] = collection.id
    @data[:name] = collection.name
    render json: @data
  end
  
   
  
  #functions taken from frontend js scripts to enable d3 visualization

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection
      @collection = Collection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      params.require(:collection).permit(:name, :description, :configuration)
    end
end
