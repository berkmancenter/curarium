# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.trays = {}

window.trays.show = () ->
  
  $('.user_tray .record_thumbnail').click (e) ->
    e.preventDefault()
    host_tray = $(this).parent()
    location = $(this).attr('href')
    console.log(location)
    host_tray.find('.record_thumbnail').hide()
    host_tray.children('h3').click (e) ->
      host_tray.find('.surrogate').remove()
      host_tray.find('h4').remove()
      host_tray.find('.record_thumbnail').show()
      $(this).unbind('click')
      undefined
    $.getJSON(
      location
      (data) ->
        host_tray.append('<h4>Surrogates</h4>')
        for image in data.parsed.image
          do (image) ->
            frame = $("<a class='record_thumbnail surogate'>").css('background-image', "url("+image+"?width=200&height=200)")
            title = $('<h3>').append(data.parsed.image.indexOf(image))
            frame.append(title)
            host_tray.append(frame)
        host_tray.append('<h4>Annotations</h4>')
        undefined
    )
    
  
  ###
  $('.user_tray .record_thumbnail').draggable(
    helper: 'clone'
  )
  ###
  undefined
