class VisualizationsController < ApplicationController
  skip_before_action :authorize, only: [:index]
  
  def index
    @collection = Collection.find(params[:collection_id])
    @properties = @collection.configuration.keys
    respond_to do |format|
      format.html { render action: "index" }
      format.json do
        if Rails.env.production?
          response = Rails.cache.fetch('all') { eval(params[:type]) }
        else
          response = eval(params[:type])
        end
        render json: response
      end
    end
  end
  
  def tag
    @collection = Collection.find(params[:collection_id])
    tags = @collection.sort_properties(params[:include],params[:exclude],params[:property], params[:minimum])
    return tags
  end
  
  def quick_search
    @collection = Collection.find(params[:collection_id])
    query = params[:terms] || ""
    result = @collection.records.where("LOWER(original::text) LIKE '%#{query.downcase}%'")
    thumbnails = []
    result.each do |thumb|
      placeholder = thumb.parsed['thumbnail']
      placeholder ||= "[]"
      thumbnails.push({
          thumbnail: JSON.parse(placeholder)[0],
          title: JSON.parse(thumb.parsed['title'])[0],
          id: thumb.id
        })
    end
    return thumbnails
  end
  
  def treemap
    minimum = params[:minimum].to_i || 0
    @collection = Collection.find(params[:collection_id])
#    @records = @collection.records.where("lower(parsed->:field) LIKE :tag", {
#      field: params[ :property ],
#      tag: '%\"' + params[ :property ] + '\"%'
#    })

    @records = @collection.records.select("lower(parsed->'#{params[ :property ]}') as parsed, count( lower(parsed->'#{params[ :property ]}') ) as id").group( "lower( parsed->'#{params[ :property ]}' )" )

    #select lower( parsed->'title' ),count( lower( parsed->'title' ) ) from "records" where "records"."collection_id" = 1 group by lower( parsed->'title' ) limit 1000

    #query = @collection.sort_properties(params[:include],params[:exclude],params[:property], minimum)
    #tmap = treemapify(query[:properties])
    #length = query[:length]
    return {
      #length: length,
      #treemap: tmap,
      #properties: query,
      records: @records
    }
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
    return thumbnails
  end
  
  def properties
    @collection = Collection.find(params[:collection_id])
    return @collection.sort_properties(params[:include],params[:exclude],params[:property])[:properties].keys
  end
  
  def list_records
    @collection = Collection.find(params[:collection_id])
    records = @collection.list_query(params[:include],params[:exclude])
    return records
  end
=begin  
  THIS WAS PART OF AN ILL FATED ATTEMPT TO MAKE VISUALIZATIONS EMBEDDABLE.
  def embed
    url = URI.parse('http://curarium.herokuapp.com/collections/1/visualizations?type=treemap&property=topics')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
       http.request(req)
    }
    render text: res.body
  end
=end  
end
