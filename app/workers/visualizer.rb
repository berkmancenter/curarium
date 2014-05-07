class Visualizer
  include SuckerPunch::Job

  def perform(params)
   @params = params
   response = eval(params[:type])
   stored_response = VizCache.new({query: encode_params, data: response})
   stored_response.save
   return response
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
    minimum = @params[:minimum].to_i || 0
    @collection = Collection.find(@params[:collection_id])
    @records = @collection.records.where("lower(parsed->:field) LIKE :tag", {
      field: @params[ :type ],
      tag: '%\"' + @params[ :property ] + '\"%'
    })
    query = @collection.sort_properties(@params[:include],@params[:exclude],@params[:property], minimum)
    tmap = treemapify(query[:properties])
    length = query[:length]
    return {length: length, treemap: tmap, properties: query, records: @records}
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
    @collection = Collection.find(@params[:collection_id])
    records = @collection.query_records(@params[:include],@params[:exclude])
    thumbnails = []
    records.each do |thumb|
      parsed = {}
      thumb.parsed.each do |key, value|
        unless ['image','thumbnail','curarium'].include? key
          unless value.nil?
            parsed[key] = eval(value)
          end
        end
      end
      placeholder = thumb.parsed['thumbnail']
      placeholder ||= "[]"
      thumbnails.push({
          thumbnail: eval(placeholder)[0],
          parsed: parsed,
          id: thumb.id
        })
    end
    return thumbnails
  end
  
  def properties
    @collection = Collection.find(@params[:collection_id])
    return @collection.sort_properties(@params[:include],@params[:exclude],@params[:property])[:properties].keys
  end
  
  def list_records
    @collection = Collection.find(@params[:collection_id])
    records = @collection.list_query(@params[:include],@params[:exclude])
    return records
  end
 
 def encode_params
    collection = @params[:collection_id].to_s
    type = @params[:type].to_s
    property = @params[:property].to_s
    include = ""
    unless @params[:include].nil?
      @params[:include].sort.each do |i|
        include += i.to_s
      end
    end
    exclude = ""
    unless @params[:exclude].nil?
      @params[:exclude].sort.each do |e|
        exclude += e.to_s
      end
    end
    return ('c'+collection+'_'+type+'_'+property+'_'+include+'_'+exclude).gsub(/:/,'_')
  end
  
end



  