# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#create

window.spotlights = {}

window.spotlights.components = []

window.spotlights.create = () ->
  $("#type").change (e)->
    $(this).val('article')
    alert('not available yet!')
    undefined
  $('#spotlight_body, #spotlight_title').val('')
  $('#new_spotlight').submit (e)->
    e.preventDefault();
    array_params = $(this).serializeArray()
    array_params.push(
      name: 'spotlight[components]'
      value: JSON.stringify(window.spotlights.components) 
    )
    object_params = {}
    for p in array_params
      object_params[p.name] = p.value
    $.ajax(
      type: "POST"
      url: '/spotlights',
      data: 
        array_params
      success: (data)->
        window.location = '/spotlights/'+data.id
      dataType : 'json',
      headers : 
        'X-CSRF-Token' : $("meta[name='csrf-token']").attr('content')
    )
  undefined
  
window.spotlights.update = (id) ->
  $("#type").change (e)->
    $(this).val('article')
    alert('not available yet!')
    undefined
    
  $.getJSON('/spotlights/'+id, (data)->
    for component, i in data.components
      render_thumbnail(component, i)
      #square = $("<div>#{i}</div>")
      window.spotlights.components.push(component)
      #$('#spotlight_components').append(square)
  )
    
  $('.edit_spotlight').submit (e)->
    e.preventDefault();
    array_params = $(this).serializeArray()
    array_params.push(
      name: 'spotlight[components]'
      value: JSON.stringify(window.spotlights.components) 
    )
    object_params = {}
    for p in array_params
      object_params[p.name] = p.value
    $.ajax(
      type: "PUT"
      url: '/spotlights/'+id,
      data:  
        array_params
      success: (data)->
        window.location = '/spotlights/'+id
      dataType : 'json',
      headers : 
        'X-CSRF-Token' : $("meta[name='csrf-token']").attr('content')
    )
  undefined

window.spotlights.display_annotation = (wrapper, content)->
  context = $('#'+wrapper).attr('class') == 'user_annotation'
  x_fit = if context then $('#'+wrapper).width()/content.width else 1
  y_fit = if context then $('#'+wrapper).height()/content.height else 1
  
  stage = new Kinetic.Stage(
    container: wrapper
    width: content.width
    height: content.height
    scale: 
      x: if content.width > content.height then y_fit else x_fit
      y: if content.width > content.height then y_fit else x_fit
  )
  layer = new Kinetic.Layer()
  stage.add(layer)
  image = new Image()
  image.src = content.image_url+"?width=10000&height=10000"
  
  
  image.onload = ->
    picture = new Kinetic.Image(
      image: image
      width: content.width
      height: content.height
      crop:
        x: content.x
        y: content.y
        width: content.width
        height: content.height
    )
    layer.add(picture)
    stage.draw()
  undefined

render_thumbnail = (data, i) ->
  switch data.type
    when 'record'
      frame = $("<div class='record_thumbnail surrogate'>").css('background-image', "url("+data.image+"?width=200&height=200)")
      title = $('<h3>').append(i)
      frame.append(title)
      $('#spotlight_components').append(frame)
    when 'annotation'
      content = data.content
      content.height = parseInt(content.height)
      content.width = parseInt(content.width)
      content.x = parseInt(content.x)
      content.y = parseInt(content.y)
      frame = $("<div class='record_annotation surrogate'>")
      stage = new Kinetic.Stage({
        container: frame[0]
        width: if content.width > content.height then 150 else content.width * 150 / content.height
        height: if content.width > content.height then content.height * 150 / content.width else 150
        x:0
        y:0
      })
      layer = new Kinetic.Layer()
      image = new Image()
      image.src = content.image_url+"?width=10000&height=10000"
      image.onload = ->
        picture = new Kinetic.Image({
          image: image
          scale:
            x: stage.getAttr('width')/image.width
            y: stage.getAttr('height')/image.height
          crop:
            width: content.width
            height: content.height
            x: content.x
            y: content.y
        })
        layer.add(picture)
        stage.add(layer)
      title = $('<h3>').append(i)
      frame.append(title)
      $('#spotlight_components').append(frame)
    when 'visualization'
      frame = $("<div class='visualization_component'>")
      $(frame).append("<p>type:#{data.type}</p>")
      $(frame).append("<p>property:#{data.body.terms.property}</p>")
      $(frame).append("<p>include:#{data.body.terms.include}</p>")
      $(frame).append("<p>exclude:#{data.body.terms.exclude}</p>")
      title = $('<h3>').append(i)
      frame.append(title)
      $('#spotlight_components').append(frame)
    else
      undefined
  undefined