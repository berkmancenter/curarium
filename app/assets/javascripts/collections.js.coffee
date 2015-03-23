work = {}
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
      work = JSON.parse($("#json").val())
      $('#parsed').append(printWork(work))
      #print work is the function that does the actual parsing.
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
       work = {}
       $('.field_wrapper').each ->
         field = $(this).attr('id')
         value = $(this).data('path')
         work[field] = value
       $("#collection_configuration").val(JSON.stringify(work))
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
            $(new_field).parent().parent().find('.value').html(traceField(work, path))
            $(new_field).parent().parent().data('path', path)
          option01 = $('<option>').attr('value', p).append(p)
          option02 = $('<option>').attr('value', "*").append("*")
          part.append(option01).append(option02)        
        $(form).append(part)
        $(new_field).data('path', path)
    $(new_field).append(form)
    value = $("<div class='value'>").append(traceField(work, path))
    $(new_field).append(value)
  undefined

#field_drop() specifies the "droppable" behavior when dragging fields from the original works into the custom curarium fields. 
#Reads the path, generates a form for modifying numeric values and gives a sample output.
field_drop = (e, d) -> 
  path = $(d.draggable).data('path')
  $(this).data('path', path)
  $(this).find('form,.value').remove()
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
          $(this).parent().parent().find('.value').html(traceField(work, path))
          $(this).parent().parent().data('path', path)
        option01 = $('<option>').attr('value', p).append(p)
        option02 = $('<option>').attr('value', "*").append("*")
        part.append(option01).append(option02)        
      $(field).append(part)
      $(this).data('path', path)
  $(this).append(field)
  value = $("<div class='value'>").append(traceField(work, path))
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

#print_work takes a JSON structure and outputs a nested definition list. 
#Keys and Array indexes are converted into Definition Terms(<dt>), 
#Objects and Arrays into Definition Lists(dl),
#numeric and string values into Definition Definitions(<dd>)
printWork = (json, path=[]) -> 
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
          item.append(printWork(json[i], localpath))
          unless typeof json[i] is 'object'
            item.append("<br>")
          localpath = path.slice(0)
      return item
    else
      title = localpath.toString()
      item = $('<dd>').data('path', localpath)
      item.append(json)
      return item
