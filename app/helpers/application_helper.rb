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
          tags += "<li><span class='key'>#{key}</span>:<span class='value'>#{value}</span></li>"
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
    tags = "<ul class='#{class_name}'"
    unless id_name == nil
      tags += "id='#{id_name}'>"
    end
    if hstore_object.class == Hash
      hstore_object.each do |key,value|
        if value.class == String
          value = eval(value)
        end
        if value.class == Hash or value.class == Array
          tags += "<li><span class='key'>#{key}</span>:</li>"+print_hstore(value, class_name)
        else
          tags += "<li><span class='key'>#{key}</span>:<span class='value'>#{value}</span></li>"
        end
      end
    elsif hstore_object.class == Array
      hstore_object.each do |value|
        if value.class == Hash or value.class ==Array
          tags += print_hstore(value, class_name)
        else
          tags += "<li><span class='value'>#{value}</span></li>"
        end
      end
    else
      tags += "<li><span class='key'>#{value}</span></li>"
    end
    return raw(tags + "</ul>")
  end

end
