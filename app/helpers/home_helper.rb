module HomeHelper
  def fractal_box(content, odd=true, count=0)
    div_class = odd ? 'odd' : 'even'
    element = "<div class=#{div_class}>"
    element += parse_content(content.shift)
    element += "</div>"
    element += "<div class=#{div_class}>"
    if count < 5 and content.length > 0
      element += fractal_box(content, !odd, count+1)
    else
      element = "<div class=last>"
      element += parse_content(content.shift)
      element += "</div>"
    end
    element += "</div>"
    return raw(element)    
  end
  
  def parse_content(element)
    if element.class == Collection
      parsed = "<div class='content' style='background-image:url(#{JSON.parse(element.records.first(order:"RANDOM()").parsed['image'])[0]})'><h3>#{link_to element.name, element}</h3><p class='collection'><span>#{element.description}</span></p></div>"
    else
      parsed = "<div class='content' style='background-color:#{rand_color}'><h3>#{link_to element.title, element}</h3><p><span>#{element.body}</span></p></div>"
    end
    return parsed
  end
  
  def rand_color
    r = (128+rand(127)).to_s(16)
    g = (128+rand(127)).to_s(16)
    b = (128+rand(127)).to_s(16)
    r, g, b = [r, g, b].map { |s| if s.size == 1 then '0' + s else s end }
    color = r + g + b
    return "#"+color
  end
  
end
