class VisualizationsController < ApplicationController
  
  def index
    respond_to do |format|
      format.html {  }
      format.json { eval(params[:type]) }
    end
  end
  
  def tag
    @collection = Collection.find(params[:collection_id])
    tags = @collection.sort_properties(params[:include],params[:exclude],params[:property])
    render json: tags
  end
  
  def treemap
    @collection = Collection.find(params[:collection_id])
    if(params[:include][0]== "" and params[:exclude][0]== "")
      treemap = treemapify(@collection.properties[params[:property]])
    else
      treemap = treemapify(@collection.sort_properties(params[:include],params[:exclude],params[:property])[:properties])
    end
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
  
end
