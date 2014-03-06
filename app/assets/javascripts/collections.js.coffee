record = {}
window.collection = {}

window.collection.visualization_controls = (properties)->
  $('form>h3').click (e)->
    $(this).data('toggle', !$(this).data('toggle'))
    t = $(this).data('toggle')
    if t
      $(this).parent().css('height', 'auto')
      $(this).css('color', 'gray')
    else
      $(this).parent().css('height', 25)
      $(this).css('color', 'white')
    
  $('#refine_search').appendTo('header #secondary_nav')
  $('#add_records_to_tray').prependTo('header #secondary_nav')
  $('#add_visualization_to_tray').appendTo('header #secondary_nav')
  
  $('.remove_element').click (e)->
    $(this).parent().remove()
  
  options_overlay = $("<div id='options_overlay'>")
  $('body').append(options_overlay)
  $('#include_value, #exclude_value').val('').keyup (e)->
    current = $(this).val()
    in_ex = $(this).attr('id').substr(0,$(this).attr('id').indexOf('_'))
    options = properties[$('#'+in_ex+'_property').val()]
    filtered = []
    for any in options
      compare = any.substring(0, current.length)
      if current.toLowerCase() == compare.toLowerCase() 
        filtered.push(any)
    if current.length > 2
      that = this
      options_overlay.show()
      options_overlay.find('*').remove()
      options_overlay.css('top', $(this).offset().top+25)
      options_overlay.css('left', $(this).offset().left)
      for option in filtered
        opt = $("<p>"+option+"</p>").click (e)->
          $(this).parent().hide()
          new_query_item = $("<span class='visualization_"+in_ex+"d'><span class='remove_element'>x</span><input value='"+$("#"+in_ex+"_property").val()+":"+$(this).html()+"' name='"+in_ex+"[]' readonly></span>")
          new_query_item.find('span').click (e)->
            $(this).parent().remove()
          $("#visualization_"+in_ex).append(new_query_item)
        options_overlay.append(opt)
  undefined


window.collection.configure = ->
  
  submited = false
  
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

window.collection.populate_fields = (configuration)->
  $('#title, #image, #thumbnail').remove()
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

field_drop = (e, d) -> #specifies the "droppable" behavior when dragging fields from the original records into the custom curarium fields. Reads the path, generates a form for modifying numeric values and gives a sample output.
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


window.collection.query = 
  length: null
  type: 'treemap'
  property: 'title'
  properties: {}
  include : []
  exclude : []
  minimum: 0

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
  window.open(window.location.pathname+'/visualizations'+window.collection.query_terms())
  undefined

window.collection.show = ->
  $.getJSON(
    ''
    (data) ->
      for property, values of data.properties
        target = $("#"+property+"_list")
        if target.length > 0
         target.data('values', values).data('property', property).click(
            (e) ->
              $('.property_list').data('property', $(this).data('property')).children('li').remove()
              for value, ammount of $(this).data('values')
                li = $("<li data-value='#{value}'>#{value} (#{ammount})</li>").append(query_button('include')).append(query_button('exclude'))
                $('.property_list').append(li)
              undefined
         )
  )
  undefined

inc_exc = (e) ->
  type = $(this).html()
  query = window.collection.query
  value = $(this).parent().data('value')
  property = $(this).parent().parent().data('property')
  query_string = property+":"+value
  remove = $("<span class='remove_element'>x</span>").click ->
    $(this).parent().remove()
    remove_index = query[type].indexOf(query_string)
    query[type].splice(remove_index,1)
  dropped = $("<span class='query_element'>").append(query_string).append(remove)
  query[type].push(query_string)
  $("#query_"+type).append dropped
  console.log 
  $.getJSON(
    window.location.pathname + "/visualizations"+ window.collection.query_terms()
    (data) ->
      $('#record_count').val(data.length)
    )

query_button = (value) ->
  $("<span class='query_button'>"+value+"</span>").click(inc_exc)