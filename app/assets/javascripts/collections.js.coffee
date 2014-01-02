record = {}
include = []
property = 'topics'

window.confCollection = ->
  $('#output .field_wrapper').droppable
    drop : field_drop
  
  $('#output .field_wrapper').click (e) ->
    console.log $(this).data('path').toString()
  
  $('#parse').submit (e) ->
    e.preventDefault()
    $('#parsed').empty()
    try
      record = JSON.parse($("#json").val())
      $('#parsed').append(printRecord(record))
      $('#parsed dd').draggable
        helper : "clone"
      $('#parsed dd').attr('title', 'drag me to a field')
      $('#parsed dt').click ->
        $(this).next('dl').toggle()
     catch e
        $('#parsed').append('invalid json')
  undefined
  
  $('form#add_field').submit (e) ->
      e.preventDefault()
      field_name = $(this).find('input[name=field_name]').val()
      new_field = $('<div>').attr('class', 'field_wrapper').attr('id', field_name).droppable
        drop : field_drop
      title = $('<p>').append(field_name)
      $(new_field).append(title)
      close = $('<div>').attr('class', 'close').append('X').click (e) ->
        $(this).parent().remove()
      $(new_field).append(close)
      $("#output form#add_field").before(new_field)
   
   $('form#submit_configuration').submit (e) ->
      e.preventDefault()
      record = {}
      $('.field_wrapper').each ->
        field = $(this).attr('id')
        value = $(this).data('path')
        record[field] = value
      $("#collection_configuration").val(JSON.stringify(record))
   

field_drop = (e, d) -> #specifies the "droppable" behavior when dragging fields from the original records into the custom curarium fields. Reads the path, generates a form for modifying numeric values and gives a sample output.
  path = $(d.draggable).data('path')
  field = $('<form>')
  for p in path
    do (p) ->
      if typeof p is 'string'
        part = $("<input readonly>").attr('class', 'part').attr('type', 'hidden').attr('value', p)
        label = $("<span>").append(p)
        $(field).append(label)
      else
        part = $("<select>").attr('class', 'part').change (e) ->
          path = []
          $(this).parent().children('select, input').each ->
            val = $(this).val()
            if isNaN(val)
              path.push(val)
            else
              path.push(parseInt(val, 10))
          $(this).parent().parent().find('.value').html(traceField(record, path))
          $(this).parent().parent().data('path', path)
        option01 = $('<option>').attr('value', p).append(p)
        option02 = $('<option>').attr('value', "*").append("*")
        part.append(option01).append(option02)        
      $(field).append(part)
      $(this).data('path', path)
  $(this).append(field)
  value = $("<div class='value'>").append(traceField(record, path))
  $(this).append(value)

#a test function to use an array of keys to read a JSON structure looking for the correspondent value. It should be transposed into Ruby to work as back end.
traceField = (object, path) ->
  if object[path[0]]?
    current = object[path[0]]
    if path.length is 1
      return current
    else
      if path[1] is "*" #if, instead of being given a numeric index, an Array is given a "*" as a key, it will iterate through all the items in the Array.
        field = []
        for i in current
          do (i)->
            npath = path.slice(1)
            npath[0] = current.indexOf(i)
            field.push(traceField(current, npath))
      else
        field = traceField(current, path.slice(1))
      return field
  else
    return null

#this function takes a JSON structure and outputs a nested definition list. Keys and Array indexes are converted into Definition Terms(<dt>), Objects and Arrays into Definition Lists(dl) and numeric and string values into Definition Definitions(<dd>)
printRecord = (json, path=[]) -> 
    localpath = path.slice(0)
    if typeof json is 'object'
      item = $('<dl>')
      if Array.isArray(json)
        item.attr('class', 'array')
      else
        item.attr('class', 'object')
      for i of json
        do (i) ->
          term = $('<dt>').append(i + ":")
          item.append(term)
          if (isNaN(i))
            localpath.push(i)
          else
            localpath.push(parseInt(i))
          item.append(printRecord(json[i], localpath))
          unless typeof json[i] is 'object'
            item.append("<br>")
          localpath = path.slice(0)
      return item
    else
      title = localpath.toString()
      item = $('<dd>').data('path', localpath)
      item.append(json)
      return item
      
window.treemap = ->
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
