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


function recordPopup(id) {
    $.getJSON("http://"+window.location.host+"/records/"+id+".json",
      function(data){
	console.log(data);
	var src = data.parsed.image[0];
	var img = new Image();
	img.src = src;
	img.onload = function(){
	    
	    $(this).css({
	      'max-height': '100%',
	      'max-width': '100%'
	    });
	  
	    $(popup).css({
	      width: img.width+320,
	      height: img.height+50,
	      'max-height': '50%',
	      'max-width': '50%'
	  });
	}
	
	$('.GLOBAL_HOLDER').css('pointer-events','none');
	
	var popup = $('<div></div>').attr('class','record_popup').css({
	    width: 500,
	    height: 500
	});
	var info = $("<div calss='record_data'><div class='titlebar'>"+id+"</div></div>");
	
	var printed_object = $("<ul class='printed_object'></ul>");
	for(var field in data.parsed){
	  var values = $("<ul class='parsed_values'></ul>");
	  for(var value in data.parsed[field]){
	    $(values).append("<li class='parsed_value'>"+data.parsed[field][value]+"</li>");
	  }
	  var key = $("<li class='parsed_key'><span>"+field+"</span></li>").append(values);
	  var parsed_field = $("<ul class='parsed_field'></ul>").attr('id',field).append(key);
	  $(printed_object).append(parsed_field);
	}
	//info.append(printed_object);
	
	var image = $('<div></div>').attr('class', 'record_img').append($("<div class='titlebar'><a href='"+"http://"+window.location.host+"/records/"+id+"' target='_blank'><span class='navigate'><img src='/assets/annotate_r.png'>go to record</span></a><div class='add_to_tray'><span class='navigate'><img src='/assets/add_to_tray_r.png'>add to tray</span><div class='expand'></div></div></div><img class='record' src="+src+">"));
	
	
	var surrogates= $('<div></div>').attr('class', 'record_surr');
	
	
	$(popup).append(info).append(image);
	$('.GLOBAL_HOLDER').append(popup);
	$(popup).click(function() { $(this).remove() });
      }
    );
}
/*
<!--- BEGIN RECORD POPUP --->	
	<div class="record_popup">
		<div class="record_data"><div class="titlebar">Record #23423 Data</div>
					<div class="expand">
				<!-- THIS IS WHERE THE PARSED RECORD INFORMATION GOES --->
				<ul class='printed_object' id='parsed_record'><ul class='parsed_field' id='date'><li class='parsed_key'><span>date</span><ul class='parsed_values'><li class='parsed_value original'>1551</li></ul></li></ul><ul class='parsed_field' id='image'><li class='parsed_key'><span>image</span><ul class='parsed_values'><li class='parsed_value original'>http://nrs.harvard.edu/urn-3:VIT.BB:4903360</li><li class='parsed_value original'>http://nrs.harvard.edu/urn-3:VIT.BB:4903361</li></ul></li></ul><ul class='parsed_field' id='names'><li class='parsed_key'><span>names</span><ul class='parsed_values'><li class='parsed_value original'>Mary, Blessed Virgin, Saint</li><li class='parsed_value original'>Jesus Christ</li><li class='parsed_value deleted'>Conte, Jacopo del</li></ul></li></ul><ul class='parsed_field' id='title'><li class='parsed_key'><span>title</span><ul class='parsed_values'><li class='parsed_value original'>Madonna and Child with two saints</li></ul></li></ul><ul class='parsed_field' id='topics'><li class='parsed_key'><span>topics</span><ul class='parsed_values'><li class='parsed_value original'>reading</li><li class='parsed_value original'>books</li><li class='parsed_value new'>tear &amp; wear</li><li class='parsed_value new'>silhouettes</li></ul></li></ul><ul class='parsed_field' id='curarium'><li class='parsed_key'><span>curarium</span><ul class='parsed_values'><li class='parsed_value original'>2000</li></ul></li></ul><ul class='parsed_field' id='thumbnail'><li class='parsed_key'><span>thumbnail</span><ul class='parsed_values'><li class='parsed_value original'>http://nrs.harvard.edu/urn-3:VIT.BB:4903360</li></ul></li></ul></ul>
			</div>
		</div>
		<div class="record_img">
			<div class="titlebar">
				<a href="/Curarium/record.html"><span class="navigate"><img src="img/annotate_r.png">go to record</span></a>
				<div class="add_to_tray"><span class="navigate"><img src="img/add_to_tray_r.png">add to tray</span>
						<div class="expand">
						<!-- THIS IS WHERE THE LIST OF TRAYS GOES --->
						<div class="tray">Tray 01<div class="add">add</div></div>
						<div class="tray">Tray 02<div class="add">add</div></div>
						<div class="tray">Tray 03<div class="add">add</div></div>
						<div class="tray">Tray 04<div class="add">add</div></div>
						<div class="tray">Tray 05<div class="add">add</div></div>
						</div>
				</div>
			</div>
			<img class="record" src="img/records/353454.jpg">
		</div>
		<div class="record_surr"><div class="titlebar"><span class="navigate close">close<img src="img/close_r.png"></span></div>
			<div class="record_cont_holder">
			<img src="img/records/18720106.jpg">
			<img src="img/records/1212121.jpg">
			<img src="img/records/32342342.jpg">
			</div>
		</div>
	</div>
	<!--- END RECORD POPUP --->*/