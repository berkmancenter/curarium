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
        npath = path.slice(2)
        field.push(traceField(current, [i].concat(npath))) for i in [0 .. current.length]
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
          console.log i
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