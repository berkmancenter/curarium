module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
    return page_title
  end

  def print_json(json_object, class_name, id_name=nil)
    tags = "<ul class='#{class_name}'"
    unless id_name == nil
      tags += "id='#{id_name}'>"
    end
    if json_object.class == Hash
      json_object.each do |key,value|
        if value.class == Hash or value.class == Array
          tags += "<li class='key'>#{key}:</li><li>"+print_json(value, class_name)+"</li>"
        else
          tags += "<li><span class='key'>#{key}:</span><span class='value'>#{value}</span></li>"
        end
      end
    elsif json_object.class == Array
      json_object.each do |value|
        if value.class == Hash or value.class ==Array
          tags += "<li>"+print_json(value, class_name)+"</li>"
        else
          tags += "<li><span class='value'>#{value}</span></li>"
        end
      end
    else
      tags += "<li><span class='key'>#{value}</span></li>"
    end
    return raw(tags + "</ul>")
  end
  
  def print_metadata(original, current, class_name,id_name=nil) #should this rather be in the controller?
    tags = "<ul class='#{class_name}' id='#{id_name}'>"
    original.each do |key, value|
      tags += "<ul class='parsed_field' id='#{key}'>"
      tags += "<li class='parsed_key'><span>#{key}</span>"
      tags += "<ul class='parsed_values'>"
      #get an instance of the original metadata and of the current version of it
      original_value = JSON.parse(original[key] || '{}')
      original_value = original_value.map(&:to_s) #make sure everything is a string... should become irrelevant.
      current_value = JSON.parse(current[key] || '{}')
      current_value = current_value.map(&:to_s)
      #compare the original value to the current one
      provided_values = original_value & current_value #values in both instances
      new_values = current_value - original_value #values only present in the 'current' version, hence new
      deleted_values = original_value - current_value #'original' values not present in the 'current' version, hence deleted
      #add li tags for each kind
      provided_values.each do |item|
        tags += "<li class='parsed_value original'>#{item}</li>"
      end
      new_values.each do |item|
        tags += "<li class='parsed_value new'>#{item}</li>"
      end
      deleted_values.each do |item|
        tags += "<li class='parsed_value deleted'>#{item}</li>"
      end
      
      tags += "</ul></li></ul>"
    end
    return raw(tags + "</ul>")
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
      return eval(hstore[field])
    else
      return []
    end
  end
  
  def print_item(item, big=false)
    container = ""
    background = ""
    if item.class == Collection
	    background = ''
      background = JSON.parse(item.records.first.parsed['image'])[0] unless !item.records.any? || item.records.first.parsed['image'].nil?
#      unless item.records[1].parsed['image'].nil?
#	stack1 = JSON.parse(item.records[1].parsed['image'])[0]
#      end
#      unless item.records[2].parsed['image'].nil?
#	stack2 = JSON.parse(item.records[2].parsed['image'])[0]
#      end
      container += "<a href='#{collection_path(item)}'><div class='gallery_item #{"item_lrg" if big}' )>"
      container += "<div class='stack1 #{"item_lrg" if big}' style='background-image:url(#{})'></div><div class='stack2 #{"item_lrg" if big}' style='background-image:url(#{})'></div>"
      container += "<div class='stack3 #{"item_lrg" if big}' style='background-image:url(#{background})'>"
      container += "<div class='object_id'>#{item.name}</div>"
      container += "<div class='collection_options'><div class='collection_options_inner'>"
      container += "<div><img src='/assets/collection_r.png'><img src='/assets/collection_w.png'> About</div><div><a href='#{collection_visualizations_path (item)}'><img src='/assets/add_r.png'><img src='/assets/add_w.png'> Activate</div></a><!--<div><img src='/assets/follow_r.png'><img src='/assets/follow_w.png'> Follow</div>-->"
      container += "</div></div></div></div>"
    elsif item.class == Spotlight
      container += "<a href='#{spotlight_path(item)}'><div class='gallery_item spotlight#{" item_lrg" if big}' >"
      container += "<div class='object_id'>#{item.title}</div>"
      container += "<div class='border'><div class='innertext'>#{item.body.gsub(/\<(\d+)\>/, "(see figure \\1)")}...</div></div>"
      container += image_tag "spotlight_tail.png"
      container += "<div class='name'><b>#{User.find(item.user_id).name}</b> <i>on #{item.created_at.strftime("%d %b %y")}</i></div>"
      container += "</div>"
    elsif item.class == Record
      unless item.parsed['image'].nil?
	background = JSON.parse(item.parsed['image'])[0]
      end
      container += "<a href='#{record_path(item)}'><div class='gallery_item#{" item_lrg" if big}' style=background-image:url('#{background}')>"
      container += "<div class='object_id'>#{item.id}</div>"
      container += "</div>"
    end
    container += "</a>"
    return raw(container)
  end
  
  def active_collection
    unless @active_collection.nil?
      return link_to @active_collection.name, collection_path(@active_collection)
    else
      return link_to "...choose a collection", collections_path
    end
  end
  
end
