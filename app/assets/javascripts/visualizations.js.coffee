window.visualization = {}

#SOME VISUALIZATION FUNCTIONS REQUIRE THE D3 VISUALIZATION LIBRARY

#OBJECT MAP
window.visualization.thumbnail = (container, source) ->
  #this visualization depends on the code of the spatialc library provided by Ole Goethe
  $('#'+container).spatialc({url: source});
  undefined

#TREEMAP
window.visualization.treemap = (container, source)->
  selected = []
  #get the current URL as a JSON response
  $.getJSON(
    source
    (items) ->
      #d3 treemap vis requires an object with a property named children
      tree({children: items.records })
      window.collection.query.length = items.length
      undefined
    )
  
  #this is the function that draws the treemap
  tree = (root) ->
    d3.selectAll('#'+container+' *').remove()
    #get the biggest value on the dataset, and store it in max_value
    max_value = 0
    for n in root.children
      do (n) ->
        if(max_value < n.id)
          max_value = n.id
    
    #set margins
    margin =
      top : 0
      right : 0
      bottom : 0
      left : 0
    
    #set width and height
    width = $('#'+container).width() - margin.left - margin.right
    height = $('#'+container).height() - margin.top - margin.bottom
    
    #create a 4-color gradient and map it to values between 0 and max_value
    color = d3.scale.linear().domain([0, max_value/8, max_value/4, max_value/2, max_value]).range(['#c83737', '#ff9955', '#5aa02c', '#2a7fff'])
    
    #create treemap layout
    treemap = d3.layout.treemap().size([width, height]).value (d) ->
      if selected.indexOf(d.parsed) < 0
        return d.id
      else
        return null
    
    #add treemap boxes
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
    
    #arrange treemap boxes within
    node = div.datum(root).selectAll(".node").data(treemap.nodes).enter().append("a").attr("href", "#").attr("class", "node").call(position).style(
      "background"
      (d) ->
        if d.id?
          return color(d.id)
    ).text(
      (d) ->
        if d.parsed != undefined
          return d.parsed + '(' + d.id + ')'
        else
          return ''
    ).on('click', click)
    
    undefined
  
  #event handler for clicking a treemap box. It adds the property represented by the box
  #to the query_terms object and then regenerates the visualization. (see collection.generate_visualization() )
  click = (e) ->
    query = window.collection.query
    value = d3.select(this).data()[0].parsed
    name = query.property+":"+value
    if query.include.indexOf(name) is -1
      query.include.push(name)
    window.collection.generate_visualization()
    return false
  
  undefined

#code for a quick search, currently broken
window.visualization.quick_search = (container, source) ->
  window.visualization.thumbnail(container, source)
  undefined