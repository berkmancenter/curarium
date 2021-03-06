module ApplicationHelper
  def title( page_title )
    if page_title.length > 0
      "#{ page_title } @ Curarium"
    else
      'Curarium'
    end
  end

  def tag_selector(hstore_object)
    tags = "<select class='tag_selector'>"
    hstore_object.each do |key, value|
      unless value.nil?
        value = JSON.parse(value)
        value.each do |item|
          tags += "<option value='#{item}'>#{key}:#{item}</option>"
        end
      end
    end
    return raw(tags + "</select>")
  end
  
  def hstore_aray (hstore, field)
    if hstore[field]
      return JSON.parse(hstore[field])
    else
      return []
    end
  end

  def active_collection
    unless @active_collection.nil?
      return link_to @active_collection.name, collection_path(@active_collection)
    else
      return link_to "...choose a collection", collections_path
    end
  end
  
  def fixed_footer?( params )
    case params[ :controller ]
    when 'works' then
      case params[ :action ]
      when 'index' then [ 'objectmap', 'treemap' ].include?( @vis )
      when 'show' then true
      else false
      end

#    when 'collections' then
#      case params[ :action ]
#      when 'new' then true
#      else false
#      end

    else false
    end
  end
end
