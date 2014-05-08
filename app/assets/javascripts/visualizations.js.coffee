window.visualization = {}

window.visualization.populate_query_menu = () ->
  in_ex = 'include'
  $('#visualization_include').empty()
  for value in window.collection.query.include
    term = $("<span class='visualization_#{in_ex}d'><span class='remove_element'>x</span><input value='#{value}' name='#{in_ex}[]' readonly></span>")
    term.find('span').click (e) ->
      $(this).parent().remove()
    $('#visualization_include').append(term)
  
  in_ex = 'exclude'
  $('#visualization_exclude').empty()
  for value in window.collection.query.exclude
    term = $("<span class='visualization_#{in_ex}d'><span class='remove_element'>x</span><input value='#{value}' name='#{in_ex}[]' readonly></span>")
    term.find('span').click (e) ->
      $(this).parent().remove()
    $('#visualization_exclude').append(term)
  undefined

window.visualization.thumbnail = (container, source) ->
  #$('#'+container).find('*').remove()
  $('#'+container).spatialc({url: source});
  undefined

window.visualization.treemap = (container, source)->
  selected = []
  $.getJSON(
    source
    (items) ->
      # d3 treemap vis requires an object with a property named children
      tree({children: items.records })
      window.collection.query.length = items.length
      undefined
    )
  
  tree = (root) ->
    d3.selectAll('#'+container+' *').remove()
    max_value = 0
    for n in root.children
      do (n) ->
        if(max_value < n.id)
          max_value = n.id
    
    margin =
      top : 0
      right : 0
      bottom : 0
      left : 0

    width = $('#'+container).width() - margin.left - margin.right

    height = $('#'+container).height() - margin.top - margin.bottom
    color = d3.scale.linear().domain([0, max_value/8, max_value/4, max_value/2, max_value]).range(['#c83737', '#ff9955', '#5aa02c', '#2a7fff'])
    
    treemap = d3.layout.treemap().size([width, height]).value (d) ->
      if selected.indexOf(d.parsed) < 0
        return d.id
      else
        return null
    
    div = d3.select('#'+container).style('overflow', 'hidden').append("div").attr('id', 'chart-container').style("position", "relative").style("width", (width + margin.left + margin.right) + "px").style("height", (height + margin.top + margin.bottom) + "px").style("left", margin.left + "px").style("top", margin.top + "px")
    
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
    
    node = div.datum(root).selectAll(".node").data(treemap.nodes).enter().append("a").attr("href", "#").attr("class", "node").call(position).style(
      "background"
      (d) ->
        if d.id?
          return color(d.id)
    ).text(
      (d) ->
        if d.parsed != undefined
          return JSON.parse(d.parsed)[0] + '(' + d.id + ')'
        else
          return ''
    ).on('click', click)
    
    undefined

  click = (e) ->
    query = window.collection.query
    value = JSON.parse(d3.select(this).data()[0].parsed)[0]
    name = query.property+":"+value
    if query.include.indexOf(name) is -1
      query.include.push(name)
    window.collection.generate_visualization()
    return false
  
  undefined

window.visualization.quick_search = (container, source) ->
  window.visualization.thumbnail(container, source)
  undefined

window.visualization.old_thumbnail = (container, source) ->
  $.getJSON(
    source
    (items) ->
      thumbs(items)
      window.collection.query.length = items.length
      undefined
    )
    
  thumbs = (items) ->
    d3.select("#"+container).selectAll('div').data(items).enter().append('div').attr('class', 'record_thumbnail').attr(
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

window.visualization.treemap_embedded = (container, source)->
  console.log("woiks")
  selected = []
  $.getJSON(
    source
    (items) ->
      tree(items.treemap)
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
    
    node = div.datum(root).selectAll(".node").data(treemap.nodes).enter().append("a").attr("href", "#").attr("class", "node").call(position).style(
      "background"
      (d) ->
        if d.size?
          return color(d.size)
    ).text( 
      (d) ->
        return d.name + '(' + d.size + ')'
    )
    
    undefined

  
  undefined

window.visualization.thumbnail_embedded = (container, source) ->
  $.getJSON(
    source
    (items) ->
      thumbs(items)
      undefined
    )
    
  thumbs = (items) ->
    d3.select("#"+container).selectAll('div').data(items).enter().append('div').attr('class', 'record_thumbnail').attr(
      'title'
      (d) -> 
        return d.id + ":" + d['title'].toString()
    ).style(
      'background-image'
      (d) -> 
        if d.thumbnail
          image_url = d.thumbnail
          return 'url(' + image_url + '?width=150&height=150)'
    )
    undefined
    
  undefined
