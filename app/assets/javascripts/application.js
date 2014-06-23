// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require jquery.geo-1.0.0-test
//= require d3
//= require turbolinks
//= require_tree .


//This is the function that controls the pop-up effect on the Explore page. 
//It was put here because that page is bound to change soon, so I did not want to integrate it with longer lasting code.
//The function is called from within the 'spatialc.js' module, line 321

function recordPopup(id) {
    // the "cover" div is a transparent block that prevents other items from being clicked
    // it occupies the whole screen and sits above everything but the popup itself.
    var cover = $("<div>");
    cover.css({
      'width':'100%',
      'height':'100%',
      'position':'fixed',
      'top':0,
      'left':0,
      'z-index': 100,
      'background-color':'black',
      'opacity': 0.5
    });
    
    $('body').append(cover);
    
    //get information about the current record.
    $.getJSON("http://"+window.location.host+"/records/"+id+".json",
      function(data){
	
	var src = data.parsed.image[0]; //record image url
	var img = new Image();
	$(img).hide();
	img.src = src;
	
	img.onload = function() {    
	    $(img).css({
	      'max-height': '100%',
	      'max-width': '100%'
	    });
	  
	    $('.record').show();
	    
	    $(popup).css({
	      width: img.width+320,
	      height: img.height+50,
	      'max-width':'95%',
	      'max-height':'80%'
	      
	  });
	};
	
	
	var popup = $('<div></div>').attr('class','record_popup').css({ //popup window
	    width: 500,
	    height: 500,
	    'z-index':101
	});
	
	var info = $("<div class='record_data expand'><div class='titlebar'>"+id+"</div></div>"); //information sidebar
	$(info).show();
	
	// This code generates a formatted version of the record data
	var printed_object = $("<ul id='parsed_record' class='printed_object'></ul>");
	
	for(var field in data.parsed){
	  var values = $("<ul class='parsed_values'></ul>");
	  for(var value in data.parsed[field]){
	    $(values).append("<li class='parsed_value'>"+data.parsed[field][value]+"</li>");
	  }
	  var key = $("<li class='parsed_key'><span>"+field+"</span></li>").append(values);
	  var parsed_field = $("<ul class='parsed_field'></ul>").attr('id',field).append(key);
	  $(printed_object).append(parsed_field);
	}
	info.append(printed_object);
	//
	
	
	var titlebar = $("<div class='titlebar'></div>");  //record title
	var link = $("<a href='"+"http://"+window.location.host+"/records/"+id+"' target='_blank'><span class='navigate'><img src='/assets/annotate_r.png'>go to record</span></a>"); //hyperlink to record
	var add_to_tray = '';
	$(titlebar).append(link);
	var image = $('<div></div>').attr('class', 'record_img').append(titlebar).append($("<img class='record' src="+src+">"));
	$('.record').hide();
	
	
	
	
	var surrogates= $('<div></div>').attr('class', 'record_surr');
	
	var close = $("<img src='../../assets/close_r.png'>").css({ //generate a close button
	  position: 'absolute',
	  top:0,
	  right: 0
	})
	
	$(popup).append(info).append(image).append(close); //append image, metadata and close button to popup
	$('.GLOBAL_HOLDER').append(popup); //append popup to document
	
	$(close).click(function() { //eventHandler for closing the popup.
	  $(popup).remove();
	  $(cover).remove();
	});
      }
    );
}

