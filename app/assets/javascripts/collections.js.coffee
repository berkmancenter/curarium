record = {}
window.collection = {}


#COLLECTION CONFIGURATION

window.collection.configure = ->
  
  submited = false
  
  $('#output .field_wrapper').droppable
    drop : field_drop
  
  #function that parses the pasted json into droppable collapsable and draggable definition lists
  $('#parse').click (e) ->
    e.preventDefault()
    $('#parsed').empty()
    try
      record = JSON.parse($("#json").val())
      $('#parsed').append(printRecord(record))
      #print record is the function that does the actual parsing.
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
      new_field = $('<div>').attr('class', 'field field_wrapper').attr('id', field_name).droppable
        drop : field_drop
      title = $('<p>').append(field_name)
      $(new_field).append(title)
      close = $('<div>').attr('class', 'close').click (e) ->
        $(this).parent().remove()
      $(new_field).append(close)
      $("#output form#add_field").before(new_field)
   
   $('.new_collection, .edit_collection').submit (e) ->
     if (!submited)
       e.preventDefault()
       record = {}
       $('.field_wrapper').each ->
         field = $(this).attr('id')
         value = $(this).data('path')
         record[field] = value
       $("#collection_configuration").val(JSON.stringify(record))
       submited = !submited
       $(this).trigger('submit')
     undefined

#This function is called by the collections/edit view to make sure that the stored version of the configuration 
#shows up when modifying the Collection.
window.collection.populate_fields = (configuration)->
  #delete the four required fields (these will be replaced by configured versions of themselves)
  $('#unique_identifier, #title, #image, #thumbnail').remove()
  #for each element in the configuration, create a field on the right part of the page, and assign it its current path.
  for field, path of configuration
    field_name = field
    new_field = $('<div>').attr('class', 'field_wrapper').attr('id', field_name).droppable
      drop : field_drop
    title = $('<p>').append(field_name)
    $(new_field).append(title)
    close = $('<div>').attr('class', 'close').append('X').click (e) ->
      $(this).parent().remove()
    $(new_field).append(close)
    $("#output form#add_field").before(new_field)
    $(new_field).data('path', path)
    form = $('<form>')
    for p in path
      do (p) ->
        if p is '*'
          p = 0
        if typeof p is 'string'
          part = $("<input readonly>").attr('class', 'part').attr('type', 'hidden').attr('value', p)
          label = $("<span>").append(p)
          $(form).append(label)
        else
          part = $("<select>").attr('class', 'part').change (e) ->
            path = []
            $(new_field).parent().children('select, input').each ->
              val = $(this).val()
              if isNaN(val)
                path.push(val)
              else
                path.push(parseInt(val, 10))
            $(new_field).parent().parent().find('.value').html(traceField(record, path))
            $(new_field).parent().parent().data('path', path)
          option01 = $('<option>').attr('value', p).append(p)
          option02 = $('<option>').attr('value', "*").append("*")
          part.append(option01).append(option02)        
        $(form).append(part)
        $(new_field).data('path', path)
    $(new_field).append(form)
    value = $("<div class='value'>").append(traceField(record, path))
    $(new_field).append(value)
  undefined

#field_drop() specifies the "droppable" behavior when dragging fields from the original records into the custom curarium fields. 
#Reads the path, generates a form for modifying numeric values and gives a sample output.
field_drop = (e, d) -> 
  path = $(d.draggable).data('path')
  $(this).data('path', path)
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

#TraceField
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

#print_record takes a JSON structure and outputs a nested definition list. 
#Keys and Array indexes are converted into Definition Terms(<dt>), 
#Objects and Arrays into Definition Lists(dl),
#numeric and string values into Definition Definitions(<dd>)
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

#COLLECTION QUERY

#this object contains the values that control visualizations:
#which type it is, which property is visualizing, which keywords are included, and which excluded.
window.collection.query = 
  length: null
  type: 'thumbnail'
  property: 'title'
  properties: {}
  include : []
  exclude : []
  minimum: 0

#this function simply encodes the preceding object into  URL parameters
window.collection.query_terms = ->
  query = window.collection.query
  type = '?type=' + query.type
  property = "&property=" + query.property
  include = ""
  exclude = ""
  for term in query.include
    do (term)->
      include = include + "&include[]=" + term
      undefined
  for term in query.exclude
    do (term)->
      exclude = exclude + "&exclude[]=" + term
      undefined
  terms = type + property + include + exclude
  return terms

window.collection.generate_visualization = ->
  window.location = (window.location.pathname+window.collection.query_terms())
  undefined

#COLLECTION SHOW
window.collection.show = ->
  
  update_controls()
  
  $('#visualization_type').change (e)->
    e.preventDefault()
    window.collection.query.type = $(this).val()
    undefined
  
  $('#visualization_property').change (e)->
    e.preventDefault()
    window.collection.query.property = $(this).val()
    undefined
  
  $('#generate_visualization').click (e)->
    window.collection.generate_visualization()
    undefined
  
  $('.property_link').click ()->
    property = $("#select_property").val()
    $('.filter').val('')
    query_type_placeholder = window.collection.query.type
    query_property_placeholder = window.collection.query.property
    window.collection.query.property = property
    window.collection.query.type = 'properties'
    $('#query_term').attr('placeholder', 'loading values...')
    $.getJSON(
      window.location.pathname + window.collection.query_terms() #load properties
      (data) ->
        $('#query_term').autocomplete {source: data, messages: {noResults: '', results: ()->}}
        $('#query_term').attr('placeholder', 'Type in a term to include or exclude')
        window.collection.query.type = query_type_placeholder
        window.collection.query.property = query_property_placeholder
    )
    undefined
  
  $('#include_button, #exclude_button').click ()->
    property = "#{$('#select_property').val()}:#{$('#query_term').val()}"
    window.collection.query[$(this).data('type')].push(property)
    $("#tag_holder").append visualization_property($(this).data('type'), property)
    undefined
  
  $('.filter').keyup (e) ->
    compare = $(this).val().toLowerCase()
    l = compare.length
    if (l > 1)
      $(this).parents('.collection_terms').first().find('.property_list li').each (e)->
        if $(this).html().toLowerCase().indexOf(compare) > -1
          $(this).show()
        else
          $(this).hide()
    undefined
    
  undefined

#when reloading the page, update_controls makes sure that the current visualization options are properly displayed
#in the visualization controls.
update_controls = () ->
  
  $("#tag_holder").empty()
  
  $('#visualization_type').val(window.collection.query.type)
  $('#visualization_property').val(window.collection.query.property)
  
  for property in window.collection.query.include
    $("#tag_holder").append visualization_property('include', property)
  
  for property in window.collection.query.exclude
    $("#tag_holder").append visualization_property('exclude', property)
  undefined


visualization_property = (type, string)->
  remove = $("<span class='remove_element'></span>").click ->
    $(this).parent().remove()
    remove_index = window.collection.query[type].indexOf(string)
    window.collection.query[type].splice(remove_index,1)
  return $("<span class='query_element #{type}'>").append($("<span class='element' data-term='#{string}'>#{string.split(':')[1]}</span>")).append(remove)
