module HomeHelper
  def parse_content(element)
    return "" if element.nil?
    
    if element.class == Collection
      parsed = "<div class='content' style='background-image:url(#{JSON.parse(element.records.first(order:"RANDOM()").parsed['image'])[0]})'><h3>#{link_to element.name, element}</h3><p class='collection'><span>#{element.description}</span></p></div>"
    else
      parsed = "<div class='content' style='background-color:#{rand_color}'><h3>#{link_to element.title, element}</h3><p><span>#{element.body}</span></p></div>"
    end
    return parsed
  end
  
  
  
=begin  
  <!-- news -->  
	<div class="gallery_item news">
		<div class="object_id"><%= image_tag "icon_twitter_w.png" %></div>
		<div class="border">
		<div class="innertext">
		All the information stored by Curarium, starting by the thousands of individual items that comprise collections, is stored in a PostgreSQL...		
		<div class="date">Posted on 11.02.14</div>
		</div>
		</div>	
	</div>
	
=end  
  def rand_color
    r = (128+rand(127)).to_s(16)
    g = (128+rand(127)).to_s(16)
    b = (128+rand(127)).to_s(16)
    r, g, b = [r, g, b].map { |s| if s.size == 1 then '0' + s else s end }
    color = r + g + b
    return "#"+color
  end
  
end
