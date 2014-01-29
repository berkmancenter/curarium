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


