# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.work = {}

window.work.parsed = {}

#THE FOLLOWING FUNCIONS DEAL WITH MODIFYING THE WORK'S METADATA

window.work.update = () ->
  window.work.parsed = read_parsed() #get the user edited values as a javascript object

  #create save changes work and give it functionality
  #save = $("<input type='submit' id='save_changes' value='Save Changes'>")
  #$('#parsed_work').append(save)
  #save.click(submit_update)
  
  #make fields editable by doubleclicking
  $('.parsed_value').dblclick(modify_field)
  
  #create "add" button and append it to each of the parsed work keys
###add_field = $("<input type='submit' value='add'>").click ()->
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
      window.work.parsed = read_parsed()
    cancel.click ()->
      new_field.remove()
    $(this).before(new_field)
    undefined
  $('.parsed_field .parsed_values').append(add_field)
  undefined
  ###
#read_parsed converts the parsed work (represented as a <UL>) into a javascript object
#it is called everytime that UL is modified and stored on window.work.parsed
read_parsed = ()->
  parsed = {}
  $('.parsed_field').each (i) ->
      key = $(this).attr('id')
      parsed[key] = []
      $(this).find('ul').find('li').not('.deleted').each (i)->
        parsed[key].push($(this).html())
        undefined
    undefined
  return parsed 


#make a put request when clicking Save Changes
submit_update = (e)->
  e.stopPropagation()
  $.ajax(
      type: "PUT"
      url: window.location.href
      data: 
        work:
          parsed: window.work.parsed
      success: (data)->
        $('.parsed_value new').css('background','#D3D3D3')
      dataType : 'json',
      headers : 
        'X-CSRF-Token' : $("meta[name='csrf-token']").attr('content')
    )
  undefined

#make fields editable by doubleclicking
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
      window.work.parsed = read_parsed()
    cancel.click ()->
      $(field).html(current)
      $(field).bind('dblclick', modify_field)
    del.click ()->
      $(field).remove()
      window.work.parsed = read_parsed()
    undefined

#display the parsed work as an accordion like widget. gets called by work.display()
collapse_parsed_information = ()->
  $('#parsed_work>ul>li>ul').each (i)->
    #that = this
    #$(this).hide(0)
    #$(this).parent().find('span').click (e)->
    #  e.stopPropagation()
      $(this).show(250)
      undefined
    undefined
  undefined



#THE FOLLOWING FUNCION DEALS WITH DISPLAYING, NAVIGATING AND ANNOTATING THE WORK. HEAVY USE OF KINETIC.JS

window.work.display = (image_url)->
  main = document.getElementById('main-canvas') #get the div to be used for displaying the work
  collapse_parsed_information()
  
  #Create the Kinetic Stage (canvas)
  stage = new Kinetic.Stage(
    container: 'main-canvas'
    height: main.offsetHeight
    width: main.offsetWidth
    draggable: true
  )

  
  
  #create Kinetic Imag and a variable to store it's zoom level (which is actually its scale)
  surrogate = new Image()
  min_scale = 0
  #set the Image url (starts loading the image). The string was a workaround to get the largest image possible from VIA or other similar type API's.
  #In the future it should become part of the importation process.
  surrogate.src = image_url
  
  #event handler for twhen the image loads
  surrogate.onload = ->
    w = surrogate.width
    h = surrogate.height
    min_scale = if w/h > main.offsetWidth/main.offsetHeight then main.offsetWidth/w else  main.offsetHeight/h 
    if min_scale > 1 #set the maximum zoomin level. If the image is smaller than the screen, make the image size the max zoom in level.
      min_scale = 1
    
    
    #scales the canvas so that the image is shown at its default size (if smaller than the screen) or is contained within the canvas(if bigger than it)
    stage.setAttrs(
      scale: 
        x: min_scale 
        y: min_scale 
    )
    
    
    #Create the a Kinetic Image object and center it.
    image = new Kinetic.Image(
      image: surrogate
      width: w
      height: h
      x: (main.offsetWidth/min_scale - surrogate.width)/2
      y: (main.offsetHeight/min_scale - surrogate.height)/2
    )
    
    #add imgage to layer
    layer.add(image)
    #this function retrieves and draws the work annotations(see below)
    get_annotations()
    undefined
  
  #create a layer and add it to the canvas
  layer = new Kinetic.Layer()
  stage.add(layer)
  stage.draw()
  
  #scrollwheel event handler, for zooming in and out.
  scroll = (e) ->
    e.preventDefault()
    stage_scale = stage.getAttr('scale').x
    delta = Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail)))/20
    #make sure that it never goes above
    if (stage_scale >= 1 and delta > 0) or (stage_scale <= min_scale and delta < 0)
      delta = 0
    
    #scale the stage
    
    stage.setAttrs(
      scale: 
        x: stage.getAttr('scale').x+delta
        y: stage.getAttr('scale').y+delta
    )
    
    #move the scaled up stage so that its center remains in the same place
    stage.setAttrs(
      x: (main.offsetWidth - main.offsetWidth/(min_scale/stage.getAttr('scale').x))/2
      y: (main.offsetHeight - main.offsetHeight/(min_scale/stage.getAttr('scale').y))/2
    )
    #draw changes in stage (you must always do this after manipulating the stage in any way. It can also be focused on layers, groups or objects)
    stage.draw()
    undefined

  #assign event handlers
  main.addEventListener('mousewheel', scroll, true);
  main.addEventListener('DOMMouseScroll', scroll, true);
  
  #placeholder rectangle for inputting annotations
  crop = new Kinetic.Rect(
    fill: 'lightblue'
    opacity: 0.25
  )
  
  #dblclick handler, it adds a translucent rectangle on screen which controls which part of the image gets cropped for annotations.
  canvas_dblclick = (event) ->
    if(event.which==1 && $( '#new_annotation' ).length > 0)
      event.preventDefault()
      stage.setAttr('draggable', false)
      canvas_x = (event.clientX - $(this).offset().left)-stage.getAttr('x')
      canvas_y = (event.clientY - $(this).offset().top - parseInt($(this).css('padding-top')))-stage.getAttr('y')
      crop.setAttrs(
        x: canvas_x/stage.getAttr('scale').x
        y: canvas_y/stage.getAttr('scale').y
      )
      layer.add(crop)
      #after dblclicking, a mousmove action takes care of resizing the rectangle.
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
    
  #on mouse up, remove the mousmove event, and convert the coordinates of the rectangle into form data for the annotation
  canvas_mouseup = (event) ->
    if(event.which==1)
      
      if ( !stage.getAttr( 'draggable' ) )
        stage.setAttr('draggable', true)
        
        #remove mousemove event
        $(this).unbind('mousemove')

        clipping =
          x: Math.floor(crop.getAttr('x')) - (main.offsetWidth/min_scale - surrogate.width)/2 #remove picture offset for clipping purposes
          y: Math.floor(crop.getAttr('y')) - (main.offsetHeight/min_scale - surrogate.height)/2 #remove picture offset for clipping purposes
          width: Math.floor(crop.getAttr('width'))
          height: Math.floor(crop.getAttr('height'))

        if ( clipping.width != 0 && clipping.height != 0 )
          clipping =
            x: if clipping.width > 0 then clipping.x else clipping.x+clipping.width
            y: if clipping.height > 0 then clipping.y else clipping.y+clipping.height
            width: Math.abs(clipping.width)
            height: Math.abs(clipping.height)
          
          #populate hidden form fields
          $("#content_x").val(clipping.x)
          $("#content_y").val(clipping.y)
          $("#content_width").val(clipping.width)
          $("#content_height").val(clipping.height)
          $("#content_image_url").val(image_url)
          
          #create a second kinetic stage for previewing your annotation
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

          $("#content_thumbnail_url").val( $( '#preview_window canvas' )[0].toDataURL() )

          if ( !$( '.expand_anno' ).is( ':visible' ) )
            $( 'label[for="ann_id"]' ).click()
    undefined
  
  
  #get work annotations, draw them on stage (if applicable) and connect them to annotations and metadata in html format
  notes_layer = null

  annotation_hover_in = ( id )->
    $('#'+id).addClass( 'hover' )

    note = notes_layer.find('#'+id)
    note.setAttrs
      stroke: 'red'
      strokeWidth: 4
    notes_layer.draw()
    undefined

  annotation_hover_out = ( id )->
    $('#'+id).removeClass( 'hover' )

    note = notes_layer.find('#'+id)
    note.setAttrs
      stroke: 'red'
      strokeWidth: 1
    notes_layer.draw()
    undefined

  get_annotations = ()->
    $.getJSON(
      window.location.pathname+'/annotations' #annotations path
      (notes) ->
        notes_layer = new Kinetic.Layer() #create new layer for annotations, represented as rectangles
        stage.add(notes_layer)
        for n in notes
          if n.image_url == image_url #check that the annotation was added to this particular image. This is necessary if the work has more than one image
            ID = "note_"+n.id #give rectangle note a unique id which matches that note's html representation
            rect = new Kinetic.Rect(
              id: ID
              x: parseInt(n.x) + (main.offsetWidth/min_scale - surrogate.width)/2 #add picture offset for display purposes
              y: parseInt(n.y) + (main.offsetHeight/min_scale - surrogate.height)/2 #add picture offset for display purposes
              stroke:'red'
              strokeWidth: 1
              width: n.width
              height: n.height
            )
            if n.tags
              rect.tags = n.tags.split( ',' )
            else
              rect.tags = ''
            
            #THE FOLLOWING ARE INTERFACE RELATED FUNCTIONS FOR INTERACTION BETWEEN NOTES, IMAGE CROPPINGS AND TAGS
            
            #make the html annotation turn red when mouse goes over its corresponding canvas annotation
            rect.on('mouseover', () ->
              annotation_hover_in( this.getAttr('id') )
            )
            
            rect.on('mouseout', () ->
              annotation_hover_out( this.getAttr('id') )
            )

            rect.on( 'click', () ->
              thumbnail = $( '#' + this.getAttr( 'id' ) )

              $.get( thumbnail.attr( 'href' ), ( popupHtml ) ->
                $.magnificPopup.open(
                  items:
                    src: popupHtml
                    type: 'inline'
                )
              )
            )
            
            #make the canvas annotations turn green when mouse hovers over one of their tags.
            $('.parsed_value').mouseover () ->
              notes = notes_layer.getChildren()
              tag = $(this).html()
              for note in notes
                if note.tags and note.tags.indexOf(tag) > -1
                  note.setAttrs
                    stroke: 'green'
                    strokeWidth: 2
                  note.draw()
              undefined
            
            $('.parsed_value').mouseout () ->
              notes = notes_layer.getChildren()
              for note in notes
                note.setAttrs
                  stroke: 'red'
                  strokeWidth: 1
              notes_layer.draw()
              undefined

            #make the canvas annotation border thicker when mouse goes over its corresponding html annotation
            $("#"+ID).mouseover ()->
              annotation_hover_in( $(this).attr('id') )
              
            $("#"+ID).mouseout ()->
              annotation_hover_out( $(this).attr('id') )
              
            #END OF INTERFACE RELATED FUNCTIONS
            
            #add rectangle to the annotations layer
            notes_layer.add(rect)
        
        #toggle annotations on or off with a checkbox. Not being used right now, but should be very easy to reimplement.
        $('#hide_anno').change ()->
          notes_layer.setAttr('visible', $(this).prop('checked'))
          undefined
        
        #redraw stage    
        stage.draw()
    )
    undefined
  
  #add event handlers to canvas
  $('#main-canvas').on('dblclick', canvas_dblclick )    
  $('#main-canvas').on('mouseup', canvas_mouseup )
  
  #event handler for dropdown menu that adds tags to annotations
  $('.tag_selector').change ()->
    current_note = $(this).parent()
    $(current_note).find('.content_tags').val($(this).val())
    undefined
  
  #THIS IS FUNCTIONALITY THAT IS NO LONGER IMPLEMENTED, BUT THAT SHOULD BE REIMPLEMENTED IN THE FUTURE
  #IT ALLOWS FOR THE EDITING OF THE IMAGE COMPONENT OF ANNOTATIONS
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
  
  undefined


