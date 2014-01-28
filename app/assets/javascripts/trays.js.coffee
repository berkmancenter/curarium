# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.trays = {}

window.trays.show = () ->
  
  $('.user_tray>h3').click (e) ->
    e.preventDefault()
    $('#user_trays h3').not(this).hide()
    $(this).parent().find('*').show()
    $('.user_tray .surrogate').remove()
    $('.user_tray h4').remove()
    $('#trays_title').click (e) ->
      $('.user_tray>h3').show()
      $('.user_tray .record_thumbnail').hide()
      $('.user_tray .surrogate').remove()
      $('.user_tray h4').remove()
      undefined
  
  $('.user_tray .record_thumbnail').click (e) ->
    e.preventDefault()
    host_tray = $(this).parent()
    location = $(this).attr('href')
    host_tray.find('.record_thumbnail').hide()
    $.getJSON(
      location
      (data) ->
        host_tray.append('<h4>Surrogates</h4>')
        for image in data.parsed.image
          do (image) ->
            frame = $("<a class='record_thumbnail surrogate'>").css('background-image', "url("+image+"?width=200&height=200)")
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
