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

  def print_hstore(hstore_object, class_name,id_name=nil)
    tags = "<ul class='#{class_name}' id='#{id_name}'>"
    hstore_object.each do |key, value|
      tags += "<ul class='parsed_field' id='#{key}'>"
      tags += "<li class='parsed_key'>#{key}"
      tags += "<ul class='parsed_values'>"
      value = JSON.parse(value)
      unless value.nil?
        value.each do |item|
          tags += "<li class='parsed_value'>#{item}</li>"
        end
      end
      tags += "</ul></li></ul>"
    end
    return raw(tags + "</ul>")
  end
  
  def hstore_aray (hstore, field)
    if hstore[field]
      return eval(hstore[field])
    else
      return []
    end
    
  end
  
end
