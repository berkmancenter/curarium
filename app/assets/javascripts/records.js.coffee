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
      x: (main.offsetWidth - (surrogate.width*min_scale))/2
      y: (main.offsetHeight - (surrogate.height*min_scale))/2 
    )
    
    image = new Kinetic.Image(
      image: surrogate
      width: w
      height: h
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
    console.log stage_scale
    if (stage_scale >= 1 and delta > 0) or (stage_scale <= min_scale and delta < 0)
      delta = 0
    stage.setAttrs(
      scale: 
        x: stage.getAttr('scale').x+delta
        y: stage.getAttr('scale').y+delta
    )
    stage.setAttrs(
      x: (main.offsetWidth - (surrogate.width*stage_scale))/2
      y: (main.offsetHeight - (surrogate.height*stage_scale))/2
    )
    stage.draw()
    undefined
  
  main.addEventListener('mousewheel', scroll, true);
  main.addEventListener('DOMMouseScroll', scroll, true);
  
  undefined
