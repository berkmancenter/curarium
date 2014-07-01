

window.spotlights = {}

#Components are Images, Annotations and visualizations that form part of a Spotlight
#While the spotlight is being edited, and before it is saved, its components live in the spotlights.components Array/
window.spotlights.components = []


#CREATE
#THIS FUNCTION GETS CALLED BY THE SPOTLIGHTS' NEW PAGE
window.spotlights.create = () ->
  $('#spotlight_body, #spotlight_title').val('')
  $('#new_spotlight').submit (e)->
    e.preventDefault();
    #serialize spotlight form and append the spotlight components to it
    array_params = $(this).serializeArray()
    array_params.push(
      name: 'spotlight[components]'
      value: JSON.stringify(window.spotlights.components) 
    )
    #convert the to make it compatible with ActiveRecord
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

#UPDATE
#THIS FUNCTION GETS CALLED BY THE SPOTLIGHTS' EDIT PAGE  
window.spotlights.update = (id) ->
  #Populate the components section with those of the Spotlight being edited
  $.getJSON('/spotlights/'+id, (data)->
    for component, i in data.components
      render_thumbnail(component, i)
      window.spotlights.components.push(component)
  )
    
  #Just like on spotlights.create, but with a PUT request
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


#HELPER FUNCTIONS
#THIS FUNCTION RENDERS AN ANNOTATION IN THE SPOTLIGHTS' SHOW ACTION (A PUBLISHED SPOTLIGHT).
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

#THIS FUNCTION TAKES A COMPONENT AND RENDERS IT ON THE PAGE ACCORDING TO ITS TYPE. IT'S CALLED BY THE SPOTLIGHT UPDATE FUNCTION
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