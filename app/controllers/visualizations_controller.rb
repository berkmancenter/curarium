class VisualizationsController < ApplicationController
  skip_before_action :authorize, only: [:index]
  
  def index
    @properties = Collection.find(params[:collection_id]).configuration.keys
    respond_to do |format|
      format.html { render action: "index" }
      format.json { eval(params[:type]) }
    end
  end
  
  def tag
    @collection = Collection.find(params[:collection_id])
    tags = @collection.sort_properties(params[:include],params[:exclude],params[:property], params[:minimum])
    render json: tags
  end
  
  def treemap
    minimum = params[:minimum].to_i || 0
    @collection = Collection.find(params[:collection_id])
    query = @collection.sort_properties(params[:include],params[:exclude],params[:property], minimum)
    tmap = treemapify(query[:properties])
    length = query[:length]
    render json: {length: length, treemap: tmap, properties: query}
  end
  
  def treemapify(data,name='main')
    branch = {}
    branch['name'] = name
    if(data.class == Array || data.class == Hash)
      branch['children'] = []
      data.each do |key, value|
        branch['children'].push(treemapify(value,key))
      end
    else
      branch['size'] = data
      return branch
    end
    return branch
  end
  
  def thumbnail
    @collection = Collection.find(params[:collection_id])
    records = @collection.query_records(params[:include],params[:exclude])
    thumbnails = []
    records.each do |thumb|
      placeholder = thumb.parsed['thumbnail']
      placeholder ||= "[]"
      thumbnails.push({
          thumbnail: eval(placeholder)[0],
          title: eval(thumb.parsed['title'])[0],
          id: thumb.id
        })
    end
    render json: thumbnails
  end
  
  def list_records
    @collection = Collection.find(params[:collection_id])
    records = @collection.list_query(params[:include],params[:exclude])
    render json: records
  end
  
end
