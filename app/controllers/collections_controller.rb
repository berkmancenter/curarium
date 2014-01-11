class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:index, :show, :check_key, :ingest, :treemap]
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
    @collection.properties = {}
    @collection.configuration.each do |field|
      @collection.properties[field[0]] = {}
    end
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
    properties = collection.properties.to_json
    properties = JSON.parse(properties)
    r = collection.records.new
    r.original = params["j"]
    r.save
    pr = {}
    pr['curarium'] = [r.id]
    configuration.each do |field|
      pr[field[0]] = collection.follow_json(r.original, field[1])
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
  
      
      
  
  #VISUALIZATIONS
  
  def tag
    @collection = Collection.find(params[:collection_id])
    tags = @collection.sort_properties(params[:include],params[:exclude],params[:property])
    render json: tags
  end
  
  def treemap
    @collection = Collection.find(params[:collection_id])
    treemap = treemapify(@collection.sort_properties(params[:include],params[:exclude],params[:property])[:properties])
    render json: treemap
  end
  
  def thumbnail
    @collection = Collection.find(params[:collection_id])
    records = @collection.query_records(params[:include],params[:exclude])
    records = records.select('parsed')
    thumbnails = []
    records.each do |thumb|
      placeholder = thumb.parsed['thumbnail']
      placeholder ||= "[]"
      thumbnails.push({
          thumbnail: eval(placeholder)[0],
          title: eval(thumb.parsed['title'])[0],
          id: eval(thumb.parsed['curarium'])[0]
        })
    end
    render json: thumbnails
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
