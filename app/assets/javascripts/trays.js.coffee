# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.trays = {}

window.trays.add_visualization = (user) ->
  $('#add_visualization_to_tray').submit (e)->
    add_viz = this
    e.preventDefault()
    option = $(add_viz).find('select[name=tray]').val()
    data = {}
    data.terms = window.collection.query
    data.url = window.location.href
    #console.log(data)
    if (option is 'new_tray')
      $.ajax
        type: "POST"
        url: "http://#{window.location.host}/users/#{user}/trays/"
        data:
          tray:
            owner_id: user
            owner_type: 'User'
            visualizations: JSON.stringify([data])
            name: $(add_viz).find("input[name=new_tray]").val()
        success: (data) ->
          alert('success: tray '+$(add_viz).find("input[name=new_tray]").val()+' created and visualization added')
        dataType: 'json'
        headers:
          'X-CSRF-Token' : $("meta[name='csrf-token']").attr('content')
    else
      $.ajax
        type: "GET"
        url: '/trays/'+option+'/add_visualization/',
        data:
            viz_data: data
        success: (data) ->
          alert('success: visualization added to '+ $(add_viz).find("input[name=new_tray]").val())
        dataType: 'json'
        headers:
          'X-CSRF-Token': $("meta[name='csrf-token']").attr('content')
  undefined

window.trays.add_records = (user) ->
  $("select[name=tray]").change (e)->
      if($(this).val() is 'new_tray')
        $(this).parent().find("input[name=new_tray]").show()
      else
        $(this).parent().find("input[name=new_tray]").hide()
    
  $('#add_records_to_tray').submit (e)->
    e.preventDefault()
    add_record = this
    option = $(add_record).find('select[name=tray]').val()
    type_placeholder = window.collection.query.type
    window.collection.query.type = 'list_records'
    $.getJSON(window.location.pathname + window.collection.query_terms(),
    (data) ->
      if(option is'new_tray')
        $.ajax
          type: "POST"
          url: "http://#{window.location.host}/users/#{user}/trays/"
          data:
            tray:
              owner_id: user
              owner_type: 'User'
              records: data
              visualizations: JSON.stringify([])
              name: $(add_record).find("input[name=new_tray]").val()
          success: (data)->
            alert('success: tray '+$(add_record).find("input[name=new_tray]").val()+' created and records added')
          dataType: 'json'
          headers:
            'X-CSRF-Token': $("meta[name='csrf-token']").attr('content')
      else
        $.ajax
          type: "GET"
          url: "/trays/#{option}/add_records/"
          data:
            records: data
          success : (data)->
            alert("success: records added to tray")
          dataType:'json'
          headers:
            'X-CSRF-Token' : $("meta[name='csrf-token']").attr('content')
      window.collection.query.type = type_placeholder
      )
    undefined

window.trays.add_record = (data, user = -1) ->
  
  $("select[name=tray]").change ()->
      if($(this).val() is 'new_tray') 
        $("input[name=new_tray]").show()
      else 
        $("input[name=new_tray]").hide()
    
  $('#add_record_to_tray').submit (e)->
    e.preventDefault()
    option = $('select[name=tray]').val()
    if(option is 'new_tray')
      $.ajax
        type: "POST"
        url: "http://#{window.location.host}/users/#{user}/trays/"
        data:
          tray:
            owner_id: user
            owner_type: 'User'
            records: data,
            visualizations: JSON.stringify([])
            name: $("input[name=new_tray]").val()
        success: (data) ->
          alert('success: tray '+$("input[name=new_tray]").val()+' created and records added')
        dataType: 'json'
        headers:
          'X-CSRF-Token': $("meta[name='csrf-token']").attr('content')
    else
      $.ajax
        type: "GET"
        url: "/trays/#{option}/add_records/"
        data:
          records: data
        success: ()->
          alert('success: records added to '+$("input[name=new_tray]").val())
        dataType: 'json'
        headers:
          'X-CSRF-Token': $("meta[name='csrf-token']").attr('content')
  undefined

window.trays.show = () ->
  
  $('.user_tray .visualization_preview').dblclick (e)->
    d = $(this).data()
    window.spotlights.components.push(d)
    $(this).remove()
    current_body = $('#spotlight_body').val()
    $('#spotlight_body').val(current_body+"{#{window.spotlights.components.indexOf(d)}}")
    document.getElementsByTagName('iframe')[0].contentWindow.document.body.innerHTML += "{#{window.spotlights.components.indexOf(d)}}"
    index = $("<h3>").append(window.spotlights.components.indexOf(d))
    c_frame = $(this).clone().append(index)
    $('#spotlight_components').append(c_frame)
    
    undefined
  
  $('.user_tray>h3').click (e) ->
    e.preventDefault()
    $('#user_trays .user_tray').not($(this).parent()).hide()
    $(this).parent().find('*').show()
    $('.user_tray .surrogate').remove()
    $('.user_tray .tray_record_images').remove()
    $('.user_tray .tray_record_annotations').remove()
    $('#trays_title').click (e) ->
      $('.user_tray').show()
      $('.user_tray .record_thumbnail, .visualization_preview').hide()
      $('.user_tray .surrogate').remove()
      $('.user_tray h4').remove()
      undefined
  
  $('.user_tray .record_thumbnail').click (e) ->
    e.preventDefault()
    host_tray = $(this).parent()
    location = $(this).attr('href')
    host_tray.find('.record_thumbnail, .visualization_preview').hide()
    $.getJSON(
      location
      (data) ->
        images_div = $("<div class='tray_record_images'>")
        host_tray.append(images_div)
        images_div.append('<h4>Surrogates</h4>')
        notes_div = $("<div class='tray_record_annotations'>")
        host_tray.append(notes_div)
        notes_div.append('<h4>Annotations</h4>')
        for image in data.parsed.image
          do (image) ->
            frame = $("<div class='record_thumbnail surrogate'>").css('background-image', "url("+image+"?width=200&height=200)")
            frame.data('id',data.parsed.curarium[0])
            frame.data('surrogate',data.parsed.image.indexOf(image))
            frame.data('image',image)
            frame.data('title',data.parsed.title[0])
            frame.data('type','record')
            title = $('<h3>').append(data.parsed.image.indexOf(image))
            frame.append(title)
            images_div.append(frame)
            $(frame).dblclick (e)->
              d = $(this).data()
              window.spotlights.components.push(d)
              $(this).remove()
              current_body = $('#spotlight_body').val()
              
              $('#spotlight_body').val(current_body+"{#{window.spotlights.components.indexOf(d)}}")
              document.getElementsByTagName('iframe')[0].contentWindow.document.body.innerHTML += "{#{window.spotlights.components.indexOf(d)}}"
              c_frame = $("<a class='record_thumbnail component'>").css('background-image', "url("+d.image+"?width=200&height=200)")
              c_title = $('<h3>').append(window.spotlights.components.indexOf(d))
              c_frame.append(c_title)
              $('#spotlight_components').append(c_frame)
              $('.wysihtml5-editor').append(c_frame)
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
              #console.log picture.getAttrs()
            title = $('<h3>').append(annotation.content.title)
            frame.append(title)
            notes_div.append(frame)
            $(frame).dblclick (e)->
              d = $(this).data()
              window.spotlights.components.push(d)
              $(this).remove()
              current_body = $('#spotlight_body').val()
              $('#spotlight_body').val(current_body+"{#{window.spotlights.components.indexOf(d)}}")
              document.getElementsByTagName('iframe')[0].contentWindow.document.body.innerHTML += "{#{window.spotlights.components.indexOf(d)}}"
              c_frame = $("<a class='record_thumbnail component'>").css('background-image', "url("+d.image+"?width=200&height=200)")
              c_title = $('<h3>').append(window.spotlights.components.indexOf(d))
              c_frame.append(c_title)
              $('#spotlight_components').append(c_frame)
              $('.wysihtml5-editor').append(c_frame)
        undefined
    )
    

  undefined
