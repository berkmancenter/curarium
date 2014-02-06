# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.trays = {}

window.trays.show = () ->
  
  $('.user_tray>h3').click (e) ->
    e.preventDefault()
    $('#user_trays .user_tray').not($(this).parent()).hide()
    $(this).parent().find('*').show()
    $('.user_tray .surrogate').remove()
    $('.user_tray h4').remove()
    $('#trays_title').click (e) ->
      $('.user_tray').show()
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
            frame.data('id',data.parsed.curarium[0])
            frame.data('surrogate',data.parsed.image.indexOf(image))
            frame.data('image',image)
            frame.data('title',data.parsed.title[0])
            frame.data('type','record')
            title = $('<h3>').append(data.parsed.image.indexOf(image))
            frame.append(title)
            host_tray.append(frame)
            $(frame).dblclick (e)->
              d = $(this).data()
              window.spotlights.components.push(d)
              $(this).remove()
              current_body = $('#spotlight_body').val()
              $('#spotlight_body').val(current_body+"<#{window.spotlights.components.indexOf(d)}>")
              c_frame = $("<a class='record_thumbnail component'>").css('background-image', "url("+d.image+"?width=200&height=200)")
              c_title = $('<h3>').append(window.spotlights.components.indexOf(d))
              c_frame.append(c_title)
              $('#spotlight_components').append(c_frame)
        host_tray.append('<h4>Annotations</h4>')
        
        for annotation in data.annotations
          do (annotation) ->
            content = annotation.content
            content.height = parseInt(content.height)
            content.width = parseInt(content.width)
            content.x = parseInt(content.x)
            content.y = parseInt(content.y)
            frame = $("<div class='record_annotation surrogate'>")
            frame.data('id',data.parsed.curarium[0])
            frame.data('surrogate',data.parsed.image.indexOf(image))
            frame.data('image',content.image_url)
            frame.data('title',content.title)
            frame.data('content',content)
            frame.data('type','annotation')
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
              console.log picture.getAttrs()
            title = $('<h3>').append(annotation.content.title)
            frame.append(title)
            host_tray.append(frame)
            $(frame).dblclick (e)->
              d = $(this).data()
              window.spotlights.components.push(d)
              $(this).remove()
              current_body = $('#spotlight_body').val()
              $('#spotlight_body').val(current_body+"<#{window.spotlights.components.indexOf(d)}>")
              c_frame = $("<a class='record_thumbnail component'>").css('background-image', "url("+d.image+"?width=200&height=200)")
              c_title = $('<h3>').append(window.spotlights.components.indexOf(d))
              c_frame.append(c_title)
              $('#spotlight_components').append(c_frame)
        undefined
    )
    

  undefined
