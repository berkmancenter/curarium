module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
    return page_title
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
  
end
