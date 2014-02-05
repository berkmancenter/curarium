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
        console.log data
        window.location = '/spotlights/'+data.id
      dataType : 'json',
      headers : 
        'X-CSRF-Token' : $("meta[name='csrf-token']").attr('content')
    )
  undefined

window.spotlights.display_annotation = (wrapper, content)->
  stage = new Kinetic.Stage(
    container: wrapper
    width: content.width
    height: content.height
  )
  layer = new Kinetic.Layer()
  stage.add(layer)
  image = new Image()
  image.src = content.image_url+"?width=10000&height=10000"
  image.onload = ->
    console.log(content)
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
