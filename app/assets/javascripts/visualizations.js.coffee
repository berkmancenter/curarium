window.visualization = {}


window.visualization.treemap = (container)->
  selected = []
  $.getJSON(
    document.location.href
    (items) ->
      tree(items)
      undefined
    )
  
  tree = (root) ->
    d3.selectAll('#'+container+' *').remove()
    max_value = 0
    for n in root.children
      do (n) ->
        if(max_value < n.size)
          max_value = n.size
    
    margin =
      top : 0
      right : 0
      bottom : 0
      left : 0
    
    width = $('#'+container).width() - margin.left - margin.right 
    height = $('#'+container).height() - margin.top - margin.bottom
    color = d3.scale.linear().domain([0, max_value/8, max_value/4, max_value/2, max_value]).range(['#c83737', '#ff9955', '#5aa02c', '#2a7fff'])
    
    treemap = d3.layout.treemap().size([width, height]).value (d) ->
      if selected.indexOf(d.name) < 0
        return d.size
      else
        return null
    
    div = d3.select('#'+container).append("div").attr('id', 'chart-container').style("position", "relative").style("width", (width + margin.left + margin.right) + "px").style("height", (height + margin.top + margin.bottom) + "px").style("left", margin.left + "px").style("top", margin.top + "px")
    
    position = ->
      this.style(
        "left"
        (d) ->
          return d.x + "px"
      ).style(
        "top" 
        (d) ->
          return d.y + "px"
      ).style(
        "width" 
        (d) ->
          return Math.max(0, d.dx - 1) + "px"
      ).style(
        "height"
        (d) ->
          return Math.max(0, d.dy - 1) + "px"
      )
      undefined
    
    node = div.datum(root).selectAll(".node").data(treemap.nodes).enter().append("div").attr("class", "node").call(position).style(
      "background"
      (d) ->
        if d.size?
          return color(d.size)
    ).text( 
      (d) ->
        return d.name + '(' + d.size + ')'
    ).on('click', click)
    
    undefined

  click = (e) -> 
    query = window.collection.query
    name = query.property+":"+d3.select(this).data()[0].name
    if query.include.indexOf(name) is -1
      query.include.push(name)
    $.getJSON(
      window.location.pathname + window.collection.query_terms()
      (data) -> 
        tree(data)
        undefined
      )
  
  undefined

window.visualization.thumbnail = (container) ->
  $.getJSON(
    window.location.href
    (items) ->
      thumbs(items)    
      undefined
    )
    
  thumbs = (items) ->
    d3.select("#"+container).selectAll('div').data(items).enter().append('div').attr('class', 'picture-container').append('div').attr('class', 'pixel').attr(
      'title'
      (d) -> 
        return d.id + ":" + d['title'].toString()
    ).style(
      'background-image'
      (d) -> 
        if d.thumbnail
          image_url = d.thumbnail
          return 'url(' + image_url + '?width=150&height=150)'
    ).on(
      'click'
      (e) ->
        id = d3.select(this).data()[0].id
        window.open('http://' + window.location.host + '/records/' + id, '_blank')
    )
    undefined
    
  undefined