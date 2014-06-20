# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.record = {}

window.record.parsed = {}

window.record.update = () ->
  window.record.parsed = read_parsed()
  save = $("<input type='submit' id='save_changes' value='Save Changes'>")
  $('#parsed_record').append(save)
  save.click(submit_update)
  $('.parsed_value').dblclick(modify_field)
  add_field = $("<input type='submit' value='add'>").click ()->
    new_field = $("<li class='parsed_value'></li>")
    input = $("<input>")
    add = $("<input type='submit' value='add'>")
    cancel = $("<input type='submit' value='cancel'>")
    new_field.append(input).append(add).append(cancel)
    add.click ()->
      $(new_field).html($(input).val())
      $(new_field).toggleClass('new',true)
      $(new_field).bind('dblclick', modify_field)
      $('#save_changes').css('background-color','red');
      window.record.parsed = read_parsed()
    cancel.click ()->
      new_field.remove()
    $(this).before(new_field)
    undefined
  $('.parsed_field .parsed_values').append(add_field)
  undefined

submit_update = (e)->
  e.stopPropagation()
  $.ajax(
      type: "PUT"
      url: window.location.href
      data: 
        record:
          parsed: window.record.parsed
      success: (data)->
        $('.parsed_value new').css('background','#D3D3D3')
      dataType : 'json',
      headers : 
        'X-CSRF-Token' : $("meta[name='csrf-token']").attr('content')
    )
  undefined

modify_field = (e) ->
    field = $(this)
    field.unbind('dblclick')
    current = $(this).html()
    input = $("<input value='#{current}'>")
    change = $("<input type='submit' value='change'>")
    cancel = $("<input type='submit' value='cancel'>")
    del = $("<input type='submit' value='delete'>")
    field.empty().append(input).append(change).append(cancel).append(del)
    change.click ()->
      $(field).html($(input).val())
      $(field).toggleClass('new', true)
      $(field).bind('dblclick', modify_field)
      window.record.parsed = read_parsed()
    cancel.click ()->
      $(field).html(current)
      $(field).bind('dblclick', modify_field)
    del.click ()->
      $(field).remove()
      window.record.parsed = read_parsed()
    undefined

read_parsed = ()->
  parsed = {}
  $('.parsed_field').each (i) ->
      key = $(this).attr('id')
      parsed[key] = []
      $(this).find('ul').find('li').not('.deleted').each (i)->
        parsed[key].push($(this).html())
        undefined
    undefined
  console.log parsed
  return parsed 

collapse_parsed_information = ()->
  $('#parsed_record>ul>li>ul').each (i)->
    that = this
    $(this).hide(0)
    $(this).find('li').click (e)->
      e.stopPropagation()
    $(this).parent().find('span').click (e)->
      e.stopPropagation()
      $('#parsed_record>ul>li>ul').hide(250)
      $(that).show(250)
      undefined
    undefined
  undefined


window.record.display = (image_url)->
  
  main = document.getElementById('main-canvas')
  
  collapse_parsed_information()
  
  
  stage = new Kinetic.Stage(
    container: 'main-canvas'
    height: main.offsetHeight
    width: main.offsetWidth
    draggable: true
  )
  
  surrogate = new Image()
  min_scale = 0
  
  surrogate.src = image_url+'?width=10000&height=10000'  #homeless paintings
  
  surrogate.onload = ->
    w = surrogate.width
    h = surrogate.height
    min_scale = if w/h > main.offsetWidth/main.offsetHeight then main.offsetWidth/w else  main.offsetHeight/h
    if min_scale > 1
      min_scale = 1
    
    stage.setAttrs(
      scale: 
        x: min_scale 
        y: min_scale 
    )
    
    image = new Kinetic.Image(
      image: surrogate
      width: w
      height: h
      x: (main.offsetWidth/min_scale - surrogate.width)/2
      y: (main.offsetHeight/min_scale - surrogate.height)/2
    )
    
    layer.add(image)
    get_annotations()
    undefined
  
  
  layer = new Kinetic.Layer()
  
  stage.add(layer)
  stage.draw()
  
  
  scroll = (e) ->
    e.preventDefault()
    stage_scale = stage.getAttr('scale').x
    delta = Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail)))/20
    if (stage_scale >= 1 and delta > 0) or (stage_scale <= min_scale and delta < 0)
      delta = 0
    stage.setAttrs(
      scale: 
        x: stage.getAttr('scale').x+delta
        y: stage.getAttr('scale').y+delta
    )
    stage.setAttrs(
      x: (main.offsetWidth - main.offsetWidth/(min_scale/stage.getAttr('scale').x))/2
      y: (main.offsetHeight - main.offsetHeight/(min_scale/stage.getAttr('scale').y))/2
    )
    stage.draw()
    undefined

  main.addEventListener('mousewheel', scroll, true);
  main.addEventListener('DOMMouseScroll', scroll, true);
  
  crop = new Kinetic.Rect(
    fill: 'lightblue'
    opacity: 0.25
  )
  
  canvas_dblclick = (event) ->
    if(event.which==1)
      event.preventDefault()
      stage.setAttr('draggable', false)
      canvas_x = (event.clientX - $(this).offset().left)-stage.getAttr('x')
      canvas_y = (event.clientY - $(this).offset().top - parseInt($(this).css('padding-top')))-stage.getAttr('y')
      crop.setAttrs(
        x: canvas_x/stage.getAttr('scale').x
        y: canvas_y/stage.getAttr('scale').y
      )
      layer.add(crop)
      $(this).on(
        'mousemove'
        (event) ->
          canvas_x = event.clientX - $(this).offset().left - stage.getAttr('x')
          canvas_y = event.clientY - $(this).offset().top - parseInt($(this).css('padding-top')) - stage.getAttr('y')
          crop.setAttrs(
            width:  (canvas_x - crop.getAttr('x')*stage.getAttr('scale').x)/stage.getAttr('scale').x
            height: (canvas_y - crop.getAttr('y')*stage.getAttr('scale').y)/stage.getAttr('scale').y
          )
          stage.draw()
        )
    undefined
    
  canvas_mouseup = (event) ->
    if(event.which==1)
      
      stage.setAttr('draggable', true)
      
      clipping =
        x: Math.floor(crop.getAttr('x')) - (main.offsetWidth/min_scale - surrogate.width)/2 #remove picture offset for clipping purposes
        y: Math.floor(crop.getAttr('y')) - (main.offsetHeight/min_scale - surrogate.height)/2 #remove picture offset for clipping purposes
        width: Math.floor(crop.getAttr('width'))
        height: Math.floor(crop.getAttr('height'))
      
      clipping =
        x: if clipping.width > 0 then clipping.x else clipping.x+clipping.width
        y: if clipping.height > 0 then clipping.y else clipping.y+clipping.height
        width: Math.abs(clipping.width)
        height: Math.abs(clipping.height)
      
      $(this).unbind('mousemove')
      $("#content_x").val(clipping.x)
      $("#content_y").val(clipping.y)
      $("#content_width").val(clipping.width)
      $("#content_height").val(clipping.height)
      $("#content_url").val(image_url)
      preview = new Kinetic.Stage(
        container: 'preview_window'
        width: if clipping.width > clipping.height then 180 else clipping.width * 180 / clipping.height
        height: if clipping.width > clipping.height then clipping.height * 180 / clipping.width else 180
      )
      preview_layer = new Kinetic.Layer()
      preview_image = new Kinetic.Image(
        image: surrogate
        crop: clipping
        scale:
          x: preview.getAttr('width')/surrogate.width
          y: preview.getAttr('height')/surrogate.height
      )
      preview_layer.add(preview_image)
      preview.add(preview_layer)
      crop.destroy()
    undefined
  
  
  
  get_annotations = ()->
    $.getJSON(
      window.location.pathname+'/annotations'
      (notes) ->
        notes_layer = new Kinetic.Layer()
        stage.add(notes_layer)
        for n in notes
          if n.content.image_url == image_url
            ID = "note_"+n.id
            rect = new Kinetic.Rect(
              id: ID
              x: parseInt(n.content.x) + (main.offsetWidth/min_scale - surrogate.width)/2 #add picture offset for display purposes
              y: parseInt(n.content.y) + (main.offsetHeight/min_scale - surrogate.height)/2 #remove picture offset for clipping purposes
              stroke:'red'
              strokeWidth: 1
              width: n.content.width
              height: n.content.height
            )
            rect.tags = n.content.tags
            
            #THE FOLLOWING ARE INTERFACE RELATED FUNCTIONS FOR INTERACTION BETWEEN NOTES, IMAGE CROPPINGS AND TAGS
            
            rect.on('mouseover',
            () ->
              $('#'+this.getAttr('id')).css
                background: 'red'
              undefined
            )
            
            rect.on('mouseout',
            () ->
              $('#'+this.getAttr('id')).css
                background: '#C3C3C3'
              undefined
            )
            
            $('.parsed_value').mouseover () ->
              #$(this).css('background-color', 'green')
              notes = notes_layer.getChildren()
              tag = $(this).html()
              for note in notes
                if note.tags and note.tags.indexOf(tag) > -1
                  note.setAttrs
                    stroke: 'green'
                    strokeWidth: 3
                  note.draw()
              undefined
            
            $('.parsed_value').mouseout () ->
              #$(this).css('background-color', 'lightgray')
              notes = notes_layer.getChildren()
              for note in notes
                note.setAttrs
                  stroke: 'red'
                  strokeWidth: 1
              notes_layer.draw()
              undefined
            
            $("#"+ID).mouseover ()->
              note = notes_layer.find('#'+$(this).attr('id'))
              note.setAttrs
                stroke: 'green'
                strokeWidth: 4
              notes_layer.draw()
              undefined
              
            $("#"+ID).mouseout ()->
              note = notes_layer.find('#'+$(this).attr('id'))
              note.setAttrs
                stroke: 'red'
                strokeWidth: 1
              notes_layer.draw()
              undefined
              
            #END OF INTERFACE RELATED FUNCTIONS
            
            notes_layer.add(rect)
        
        $('#annotation_toggle').change ()->
          notes_layer.setAttr('visible', $(this).prop('checked'))
          undefined
            
        stage.draw()
    )
    undefined
  
  
  $('#main-canvas').on('dblclick', canvas_dblclick )    
  $('#main-canvas').on('mouseup', canvas_mouseup )
  
  $('.tag_selector').change ()->
    div = $("<input type='text'class='annotation_tag' readonly='readonly' name='annotation[content][tags][]'>").val($(this).val())
    $(this).before(div)
    undefined
  
  $('.edit_clipping').click ()->
    current_note = $(this).parent()
    id = $(this).parent().attr('id')
    rect = stage.find("##{id}")
    stage.setAttr('draggable', false)
    $('#main-canvas').unbind('dblclick')    
    $('#main-canvas').unbind('mouseup')
    notes_layer = stage.getLayers()[1]
    notes_layer.remove()
    stage.draw()
    $('#main-canvas').mousedown (event)->
      canvas_x = (event.clientX - $(this).offset().left)-stage.getAttr('x')
      canvas_y = (event.clientY - $(this).offset().top - parseInt($(this).css('padding-top')))-stage.getAttr('y')
      crop.setAttrs(
        x: canvas_x/stage.getAttr('scale').x
        y: canvas_y/stage.getAttr('scale').y
      )
      layer.add(crop)
      $(this).mousemove (event)->
        canvas_x = event.clientX - $(this).offset().left - stage.getAttr('x')
        canvas_y = event.clientY - $(this).offset().top - parseInt($(this).css('padding-top')) - stage.getAttr('y')
        crop.setAttrs(
          width:  (canvas_x - crop.getAttr('x')*stage.getAttr('scale').x)/stage.getAttr('scale').x
          height: (canvas_y - crop.getAttr('y')*stage.getAttr('scale').y)/stage.getAttr('scale').y
        )
        stage.draw()
        undefined
    undefined
    $('#main-canvas').mouseup (event)->
      clipping =
        x: Math.floor(crop.getAttr('x')) - (main.offsetWidth/min_scale - surrogate.width)/2 #remove picture offset for clipping purposes
        y: Math.floor(crop.getAttr('y')) - (main.offsetHeight/min_scale - surrogate.height)/2 #remove picture offset for clipping purposes
        width: Math.floor(crop.getAttr('width'))
        height: Math.floor(crop.getAttr('height'))
      
      rect.setAttrs(
        x: crop.getAttr('x')
        y: crop.getAttr('y')
        width: crop.getAttr('width')
        height: crop.getAttr('height')
      )
      
      $(current_note).find('.content_x').val(clipping.x)
      $(current_note).find('.content_y').val(clipping.y)
      $(current_note).find('.content_width').val(clipping.width)
      $(current_note).find('.content_height').val(clipping.height)
      
      $(this).unbind()
      $(this).on('dblclick', canvas_dblclick )    
      $(this).on('mouseup', canvas_mouseup )
      stage.setAttr('draggable', true)
      stage.add(notes_layer)
      crop.destroy()
      stage.draw()
      undefined
    undefined
  
  $('#record_annotate h4').click ()->
    $(this).data('clicked', !$(this).data('clicked'))
    window = $(this).parent()
    if $(this).data('clicked')
      window.css('height','auto')
    else
      window.css('height',15)
  
  undefined
