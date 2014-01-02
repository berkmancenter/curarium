`window.visualizations = {}`
include = []
exclude = []
property = 'topics'

window.visualizations.treemap = ->
  selected = []
  $.getJSON(
    document.URL + '/treemap?property=' + property + '&include='
    (items) ->
      tree(items)
      undefined
    )

  tree = (root) ->
    max_value = 0
    for n in root.children
      do (n) ->
        if(max_value < n.size)
          max_value = n.size
    
    
    d3.selectAll('section#collection_canvas *').remove()
    
    
    
    margin =
      top : 0
      right : 0
      bottom : 0
      left : 0
    
    
    width = $("section#collection_canvas").width() - margin.left - margin.right 
    height = $("section#collection_canvas").height() - margin.top - margin.bottom

    color = d3.scale.linear().domain([0, max_value/8, max_value/4, max_value/2, max_value]).range(['#c83737', '#ff9955', '#5aa02c', '#2a7fff'])
    
    
    
    treemap = d3.layout.treemap().size([width, height]).value (d) ->
      if selected.indexOf(d.name) < 0
        return d.size
      else
        return null
    
    
    
    div = d3.select("section#collection_canvas").append("div").attr('id', 'chart-container').style("position", "relative").style("width", (width + margin.left + margin.right) + "px").style("height", (height + margin.top + margin.bottom) + "px").style("left", margin.left + "px").style("top", margin.top + "px")
    
    
    
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
        return d.name
    ).on('click', click)
    
    undefined
    


  click = (e) -> 
    name = property+":"+d3.select(this).data()[0].name
    if include.indexOf(name) is -1
      include.push(name)
    #placeholder()

    #populate_path()
    $.getJSON(
      document.URL + '/treemap?property=' + property + window.terms()
      (data) -> 
        tree(data)
        undefined
      )

  undefined

window.terms = ->
  terms = ""
  for term in include
    do (term)->
      terms = terms + "&include[]=" + term
      undefined
  if terms is ""
    terms = "&include[]="
  return terms
