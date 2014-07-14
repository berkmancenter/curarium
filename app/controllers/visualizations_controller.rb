class VisualizationsController < ApplicationController
  skip_before_action :authorize, only: [:index]
  
  def index
    @collection = Collection.find(params[:collection_id])
    cookies[:active_collection] = params[:collection_id]
    @active_collection = @collection
    @properties = @collection.configuration.keys
    respond_to do |format|
      format.html { render action: "index" }
      format.js { render action: "index" }
      format.json do
        viz_cache = Curarium::Application.config.local['viz_cache']
        response = VizCache.find_by(query: encode_params) if viz_cache
        if response.nil?
          response = treemap
          if viz_cache
            stored_response = VizCache.new({query: encode_params, data: response})
            stored_response.save
          end
        else
          response = response.data
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

    # a lot of this should move to records model
    
    where_clause = ActiveRecord::Base.send( :sanitize_sql_array, [ 'where collection_id = %s', params[:collection_id] ] )

    if params[:include].present?
      # break out values to avoid SQL injection
      where_values = ['']

      params[:include].each_with_index { |p, i|
        values = p.split ':'

        if i > 0
          where_values[0] = where_values[0] + ' AND '
        end

        where_values[0] = where_values[0] + "lower(parsed->'#{values[0]}') like '%s'"
        where_values << "%#{values[1].downcase}%"
      }

      where_clause = where_clause + " AND ( #{ActiveRecord::Base.send( :sanitize_sql_array, where_values )} )"
    end

    if params[:exclude].present?
      # break out values to avoid SQL injection
      where_values = ['']

      params[:exclude].each_with_index { |p, i|
        values = p.split ':'

        if i > 0
          where_values[0] = where_values[0] + ' OR '
        end

        where_values[0] = where_values[0] + "lower(parsed->'#{values[0]}') like '%s'"
        where_values << "%#{values[1].downcase}%"
      }

      where_clause = where_clause + " AND NOT ( #{ActiveRecord::Base.send( :sanitize_sql_array, where_values )} )"
    end

    # ["a", "b, b", "c"]
    # ["a%SPLIT%b, b%SPLIT%c"]
    # a%SPLIT%b, b%SPLIT%c
    # a -- b, b -- c
    sql = %[select values as parsed, count(values) as id from (
      SELECT  trim(
        both from unnest(
          string_to_array(
            regexp_replace(
              regexp_replace(
                lower(parsed->'#{params[ :property ]}'), '", "', '%SPLIT%', 'g'
              ), '[\\[\\]"]', '', 'g'
            ), '%SPLIT%'
          )
        )
      ) as values
      FROM "records"
      #{where_clause}
    ) as subquery
    group by values]

    @records = ActiveRecord::Base.connection.execute(sql)

    return {
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
      parsed = {}
      thumb.parsed.each do |key, value|
        unless ['image','thumbnail','curarium'].include? key
          unless value.nil?
            parsed[key] = JSON.parse(value)
          end
        end
      end
      placeholder = thumb.parsed['thumbnail']
      placeholder ||= "[]"
      thumbnails.push({
          thumbnail: JSON.parse(placeholder)[0],
          parsed: parsed,
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
  
  def encode_params
    collection = params[:collection_id].to_s
    type = params[:type].to_s
    property = params[:property].to_s
    include = ""
    unless params[:include].nil?
      params[:include].sort.each do |i|
        include += i.to_s
      end
    end
    exclude = ""
    unless params[:exclude].nil?
      params[:exclude].sort.each do |e|
        exclude += e.to_s
      end
    end
    return ('c'+collection+'_'+type+'_'+property+'_'+include+'_'+exclude).gsub(/:/,'_')
  end
  

end
