# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.record = {}

window.record.display = (image_url)->
  
  main = document.getElementById('main-canvas')
  
  stage = new Kinetic.Stage(
    container: 'main-canvas'
    height: main.offsetHeight
    width: main.offsetWidth
    draggable: true
  )
  
  surrogate = new Image()
  min_scale = 0
  
  #surrogate.src = 'http://www.padsandpanels.com/wp-content/uploads/2010/03/familyguy5.jpg' #wide image
  #surrogate.src = 'http://ninapaley.com/mimiandeunice/wp-content/uploads/2010/08/ME_164_SomethingForNothing.png' #wide image, wider than screen  
  #surrogate.src = 'http://cameronanstee.files.wordpress.com/2012/04/something-else-01.jpg' #tall image
  #surrogate.src = 'http://www.thepencilmademedoit.com/wp-content/uploads/2012/08/Day-05-Something-Green.jpg' #square image
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
    stage.draw()
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
  
  $('#main-canvas').on(
    'dblclick'
    (event) ->
      if(event.which==1)
        event.preventDefault()
        stage.setAttr('draggable', false)
        canvas_x = (event.clientX - $(this).offset().left)-stage.getAttr('x')
        canvas_y = (event.clientY - $(this).offset().top)-stage.getAttr('y')
        crop.setAttrs(
          x: canvas_x/stage.getAttr('scale').x
          y: canvas_y/stage.getAttr('scale').y
        )
        layer.add(crop)
        $(this).on(
          'mousemove'
          (event) ->
            canvas_x = event.clientX - $(this).offset().left - stage.getAttr('x')
            canvas_y = event.clientY - $(this).offset().top - stage.getAttr('y')
            crop.setAttrs(
              width:  (canvas_x - crop.getAttr('x')*stage.getAttr('scale').x)/stage.getAttr('scale').x
              height: (canvas_y - crop.getAttr('y')*stage.getAttr('scale').y)/stage.getAttr('scale').y
            )
            stage.draw()
          )
    )
    
  $('#main-canvas').on(
    'mouseup'
    (event) ->
      if(event.which==1)

        o_x = 
        
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
        
        $("input[name='content[x]']").val(clipping.x)
        $("input[name='content[y]']").val(clipping.y)
        $("input[name='content[width]']").val(clipping.width)
        $("input[name='content[height]']").val(clipping.height)
        $("input[name='content[image_url]']").val(image_url)
        
        preview = new Kinetic.Stage(
          container: 'preview_window'
          width: if clipping.width > clipping.height then 300 else clipping.width * 300 / clipping.height
          height: if clipping.width > clipping.height then clipping.height * 300 / clipping.width else 300
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
    )
  
  $.getJSON(
    window.location.pathname+'/annotations'
    (notes) ->
      notes_layer = new Kinetic.Layer()
      stage.add(notes_layer)
      for n in notes
        if n.content.image_url == image_url
          console.log(n)
          rect = new Kinetic.Rect(
            x: parseInt(n.content.x) + (main.offsetWidth/min_scale - surrogate.width)/2 #add picture offset for display purposes
            y: parseInt(n.content.y) + (main.offsetHeight/min_scale - surrogate.height)/2 #remove picture offset for clipping purposes
            stroke:'red'
            width: n.content.width
            height: n.content.height
            
          )
          notes_layer.add(rect)
      
      $('#annotation_toggle').change ()->
        notes_layer.setAttr('visible', $(this).prop('checked'))
        undefined
          
      stage.draw()
  )
  
  $('#record_annotate h4').click ()->
    $(this).data('clicked', !$(this).data('clicked'))
    window = $(this).parent()
    if $(this).data('clicked')
      window.css('height','auto')
    else
      window.css('height',15)
  
  undefined
