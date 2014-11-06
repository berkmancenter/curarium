window.trays = {}

###
THIS FUNCTIONS CONTROL BOTH THE ADDING OF WORKS/VISUALIZATIONS TO THE TRAYS,
THE DISPLAYING OF TRAYS WHEN EDITING WORKS, AND THE ADDING OF WORKS/VISUALIZATIONS
FROM TRAYS TO SPOTLIGHTS

Trays store works in an array of integers (the works id's), and they store visualizations
in a json array, where each item is an object that stores the visualization's parameter.
###

#FUNCTIONS FOR ADDING DATA TO TRAYS
#function that initializes the adding of visualizations to trays
window.trays.add_visualization = (user) ->
  $('#add_visualization_to_tray').submit (e)->
    add_viz = this
    e.preventDefault()
    option = $(add_viz).find('select[name=tray]').val()
    
    #when saving a viz, the data gets stored as an object and as a URI. This is redundant but both representations serve different purposes.
    data = {}
    data.terms = window.collection.query
    data.url = window.location.href
    #adding data to a tray works differently depending on whether you're creating a new tray or adding information to an existing one.
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
    #if the tray exists, add_visualization calls the custom 'add_visualization' action on the trays controller
    #it should be a PUT and not a GET request, but at the time I couldn't make it work with PUT.
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

#function that initializes the adding of works to trays, in the explore page
window.trays.add_works = (user) ->
  $("select[name=tray]").change (e)->
      if($(this).val() is 'new_tray')
        $(this).parent().find("input[name=new_tray]").show()
      else
        $(this).parent().find("input[name=new_tray]").hide()
    
  
  #THIS FUNCTION ADDS A GROUP OF WORKS TO A TRAY. IT IS DESIGNED SO THAT, IF YOU NARROW YOUR SEARCH TERMS TO INCLUDE A SMALL SET OF WORKS
  #YOU CAN DIRECTLY ADD THAT SET TO A TRAY. THIS GETS CALLED FROM THE VISUALIZATIONS INDEX VIEW.
  $('#add_works_to_tray').submit (e)->
    e.preventDefault()
    add_work = this
    option = $(add_work).find('select[name=tray]').val()
    
    #in order to get the work id's, a special action on the 'visualizations' controller is called
    #first we add the current visualization mode to a placeholder variable, then we change the collection.query.type object to 'list works'
    #and then we do a JSON requests.
    type_placeholder = window.collection.query.type
    window.collection.query.type = 'list_works'
    $.getJSON(window.location.pathname + window.collection.query_terms(),
    
    #again, adding data to a tray works differently depending on whether you're creating a new tray or adding information to an existing one.
    (data) ->
      if(option is'new_tray')
        $.ajax
          type: "POST"
          url: "http://#{window.location.host}/users/#{user}/trays/"
          data:
            tray:
              owner_id: user
              owner_type: 'User'
              works: data
              visualizations: JSON.stringify([]) #when adding works to a new tray, we create an empty visualizations array as a placeholder for future viz storage.
              name: $(add_work).find("input[name=new_tray]").val()
          success: (data)->
            alert('success: tray '+$(add_work).find("input[name=new_tray]").val()+' created and works added')
          dataType: 'json'
          headers:
            'X-CSRF-Token': $("meta[name='csrf-token']").attr('content')
      else
        $.ajax
          type: "GET"
          url: "/trays/#{option}/add_works/"
          data:
            works: data
          success : (data)->
            alert("success: works added to tray")
          dataType:'json'
          headers:
            'X-CSRF-Token' : $("meta[name='csrf-token']").attr('content')
      window.collection.query.type = type_placeholder #set the visualization type to whatever it was before saving the works.
      )
    undefined


#ADD A SINGLE WORK TO A TRAY. GETS CALLED FROM THE WORK PAGE, AND SHOULD ALSO BE CALLED FROM THE WORK POPUP IN THE VISUALIZATIONS INDEX PAGE.
 window.trays.add_work = (data,user) ->
  #looks for the list of existing trays, and assigns an event handler to each one of them
  $('.tray .add').each ()->
    $(this).click (e)->
      e.stopPropagation()
      tray_id = $(this).parent().data('tray')
      tray_name = $(this).parent().data('tray_name')
      $.ajax
        type: "GET" #should be PUT, couldn't make it work
        url: "/trays/#{tray_id}/add_works/"
        data:
          works: data
        success: ()->
          alert("success: works added to #{tray_name}")
        dataType: 'json'
        headers:
          'X-CSRF-Token': $("meta[name='csrf-token']").attr('content')
    undefined
  undefined
  
  #looks for the new tray field, and adds an event handler
  $('.new_tray .add').click (e)->      
     name = $(this).parent().find('input').val()
     $.ajax
      type: "POST"
      url: "http://#{window.location.host}/users/#{user}/trays/"
      data:
        tray:
          owner_id: user
          owner_type: 'User'
          works: data,
          visualizations: JSON.stringify([]) #add empty visualizations array
          name: name
      success: (data) ->
        alert("success: tray #{name} created and records added")
        console.log(data)
        $('.new_tray .input').val('')
        $('.new_tray').after($("<div class='tray' data-tray='#{data.id}' data-tray_name='#{name}'>#{name}<div class='add'>add</div></div>"))
      dataType: 'json'
      headers:
        'X-CSRF-Token': $("meta[name='csrf-token']").attr('content')
    undefined
 undefined


#FUNCTIONS THAT THE DISPLAY OF TRAYS ON THE SPOTLIGHT EDITOR, AND THE ADDING OF TRAY CONTENT TO THE SPOTLIGHTS
window.trays.show = () ->
  
  #event handler to add a visualizations to a spotlight when doubleclicking the viz.
  #it removes the viz from the tray representation, adds it to the components bar, and pushes its
  #data to the spotlights.components array.
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
  
  #event handler for expanding trays by clicking on them.
  $('.user_tray>h3').click (e) ->
    e.preventDefault()
    $('#user_trays .user_tray').not($(this).parent()).hide()
    $(this).parent().find('*').show()
    $(this).parent().css('height','400px')
    $('.user_tray .surrogate').remove()
    $('.user_tray .tray_work_images').remove()
    $('.user_tray .tray_work_annotations').remove()
    
  #event handler for collapsing trays by clicking on the 'x' button.
  $('.close_tray').click (e) ->
    $(this).parent().css('height',20)
    $(this).hide()
    $('.user_tray').show()
    $('.surrogate').remove()
    $(this).parent().find('h4, .tray_works, .tray_visualizations').hide()
    undefined
  
  
  #This function handles the display of individual works in trays. Since works can have many images, plus annotations, when an individual
  #work thumbnail is clicked, that work data is fetched with a getSJON #and thumbnails of individual surrogates(images) and annotations are generated.
  #The function also assigns dblclick event handlers to add individual images and annotations to the Spotlight
  $('.user_tray .work_thumbnail').click (e) ->
    e.preventDefault()
    #hide other works in the tray
    host_tray = $(this).parent().parent()
    location = $(this).attr('href')
    host_tray.find('.tray_works, .tray_visualizations, h4').hide()
    $.getJSON(
      location
      (data) ->
        images_div = $("<div class='tray_work_images'>")
        host_tray.append(images_div)
        images_div.append('<h4>Surrogates</h4>')
        notes_div = $("<div class='tray_work_annotations'>")
        host_tray.append(notes_div)
        notes_div.append('<h4>Annotations</h4>')
        #this loop renders the surrogate images, with their correspondent dblclick handler
        for image in data.parsed.image
          do (image) ->
            frame = $("<div class='work_thumbnail surrogate'>").css('background-image', "url("+image+"?width=200&height=200)")
            frame.data('id',data.id)
            frame.data('surrogate',data.parsed.image.indexOf(image))
            frame.data('image',image)
            frame.data('title',data.parsed.title[0])
            frame.data('type','work')
            title = $('<h3>').append(data.parsed.image.indexOf(image))
            frame.append(title)
            images_div.append(frame)
            #add image to spotlight
            $(frame).dblclick (e)->
              d = $(this).data()
              window.spotlights.components.push(d)
              $(this).remove()
              current_body = $('#spotlight_body').val()
              $('#spotlight_body').val(current_body+"{#{window.spotlights.components.indexOf(d)}}")
              document.getElementsByTagName('iframe')[0].contentWindow.document.body.innerHTML += "{#{window.spotlights.components.indexOf(d)}}"
              c_frame = $("<a class='work_thumbnail component'>").css('background-image', "url("+d.image+"?width=200&height=200)")
              c_title = $('<h3>').append(window.spotlights.components.indexOf(d))
              c_frame.append(c_title)
              $('#spotlight_components').append(c_frame)
              $('.wysihtml5-editor').append(c_frame)
        #this loop renders the annotations, with their correspondent dblclick handler
        for annotation in data.annotations
          do (annotation) ->
            content = annotation.content
            content.height = parseInt(content.height)
            content.width = parseInt(content.width)
            content.x = parseInt(content.x)
            content.y = parseInt(content.y)
            frame = $("<div class='work_annotation surrogate'>")
            frame.data('id',data.id)
            frame.data('surrogate',data.parsed.image.indexOf(image))
            frame.data('image',content.image_url)
            frame.data('title',content.title)
            frame.data('content',content)
            frame.data('type','annotation')
            #the rendering of the annotations requires a Kinetic stage (canvas) to be setup
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
            title = $('<h3>').append(annotation.content.title)
            frame.append(title)
            notes_div.append(frame)
            #add annotation to spotlight
            $(frame).dblclick (e)->
              d = $(this).data()
              window.spotlights.components.push(d)
              $(this).remove()
              current_body = $('#spotlight_body').val()
              $('#spotlight_body').val(current_body+"{#{window.spotlights.components.indexOf(d)}}")
              document.getElementsByTagName('iframe')[0].contentWindow.document.body.innerHTML += "{#{window.spotlights.components.indexOf(d)}}"
              c_frame = $("<a class='work_thumbnail component'>").css('background-image', "url("+d.image+"?width=200&height=200)")
              c_title = $('<h3>').append(window.spotlights.components.indexOf(d))
              c_frame.append(c_title)
              $('#spotlight_components').append(c_frame)
              $('.wysihtml5-editor').append(c_frame)
        undefined
    )
  undefined
