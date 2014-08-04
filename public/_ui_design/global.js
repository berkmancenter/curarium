$(document).ready(function() {
var infobar_orginal = $("#hintbar_desc").html();
var infobar_css = $("#hintbar_desc").css('color');
var highlight = 
$('#vocab span, .FRONTPAGE_INFOBAR #about_links span').hover(
	function() {$(this).css({'cursor': 'pointer','text-decoration': 'underline'});},
	function() {$(this).css({'cursor': 'pointer','text-decoration': 'none'});});
	
	
$(".FRONTPAGE_INFOBAR #what").click(function() {
    $('html, body').animate({scrollTop: $(".ABOUT #what").offset().top}, 1000);});
$(".FRONTPAGE_INFOBAR #vocab").click(function() {
    $('html, body').animate({scrollTop: $(".ABOUT #vocab").offset().top}, 1000);});
$(".FRONTPAGE_INFOBAR #how").click(function() {
    $('html, body').animate({scrollTop: $(".ABOUT #how").offset().top}, 1000);});
$(".FRONTPAGE_INFOBAR #contact").click(function() {
    $('html, body').animate({scrollTop: $(".ABOUT #contact").offset().top}, 1000);});


	
$("#vocab #vann").click(function() {
    $('html, body').animate({scrollTop: $("#how #vann").offset().top}, 1000);
    $('#how span').css({"text-decoration": "none","color":"black"},1000);
   	$('#how #vann').css({"color":infobar_css,"text-decoration":"underline"},1000);
});
$("#vocab #vcir").click(function() {
    $('html, body').animate({scrollTop: $("#how #vcir").offset().top}, 1000);
    $('#how span').css({"text-decoration": "none","color":"black"},1000);
    $('#how #vcir').css({"color":infobar_css,"text-decoration":"underline"},1000);
});
$("#vocab #vcoll").click(function() {
    $('html, body').animate({scrollTop: $("#how #vcoll").offset().top}, 1000);
    $('#how span').css({"text-decoration": "none","color":"black"},1000);
    $('#how #vcoll').css({"color":infobar_css,"text-decoration":"underline"},1000);
});
$("#vocab #ving").click(function() {
    $('html, body').animate({scrollTop: $("#how #ving").offset().top}, 1000);
    $('#how span').css({"text-decoration": "none","color":"black"},1000);
    $('#how #ving').css({"color":infobar_css,"text-decoration":"underline"},1000);
});
$("#vocab #vrec").click(function() {
    $('html, body').animate({scrollTop: $("#how #vrec").offset().top}, 1000);
    $('#how span').css({"text-decoration": "none","color":"black"},1000);
    $('#how #vrec').css({"color":infobar_css,"text-decoration":"underline"},1000);
});
$("#vocab #vstra").click(function() {
    $('html, body').animate({scrollTop: $("#how #vstra").offset().top}, 1000);
    $('#how span').css({"text-decoration": "none","color":"black"},1000);
    $('#how #vstra').css({"color":infobar_css,"text-decoration":"underline"},1000);
});	
$("#vocab #vspo").click(function() {
    $('html, body').animate({scrollTop: $("#how #vspo").offset().top}, 1000);
    $('#how span').css({"text-decoration": "none","color":"black"},1000);
    $('#how #vspo').css({"color":infobar_css,"text-decoration":"underline"},1000);
});	
$("#vocab #vtra").click(function() {
    $('html, body').animate({scrollTop: $("#how #vtra").offset().top}, 1000);
    $('#how span').css({"text-decoration": "none","color":"black"},1000);
    $('#how #vtra').css({"color":infobar_css,"text-decoration":"underline"},1000);
});	
$('#toggle_collections, #toggle_spotlights, #toggle_explore, #toggle_user').hover(
	function() {
    $(this).find("img").stop().fadeToggle(200);
    $(this).find("a").stop().animate({"color":infobar_css},200);
    $("#about_links").stop().fadeToggle(200);
	},
	function() { 
	$(this).find("img").stop().fadeToggle(200);
	$(this).find("a").stop().animate({"color":"black"},200);
	$("#about_links").stop().fadeToggle(200);
	});
// MENU TOGGLE CURARIUM

$('#toggle_curarium').hover(
	function() {
	$('#dropdown_curarium', this).stop().show('blind');
	$("#about_links").stop().fadeToggle(200);
	if ($('#cura').length > 0) {	
	$("#cura").stop().fadeToggle(200).css({"color":infobar_css},200);$('#orig').stop().fadeToggle(200);
	}},
    function() {   
    $('#dropdown_curarium', this).stop().hide('blind');
    $("#about_links").stop().fadeToggle(200);
	if ($('#cura').length > 0) {	
	$("#cura").stop().fadeToggle(200).css({"color":infobar_css},200);$('#orig').stop().fadeToggle(200);
	}});


//COLLECTIONS
$('#toggle_collections').hover(
	function() {
    $('#coll').stop().fadeToggle(200);$('#orig').stop().fadeToggle(200);
    $('#hint_coll').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);},
	function() { 
	$('#coll').stop().fadeToggle(200); $('#orig').stop().fadeToggle(200);
	$('#hint_coll').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);});
//SPOTLIGHTS
$('#toggle_spotlights').hover(
	function() {
    $('#spot').stop().fadeToggle(200);$('#orig').stop().fadeToggle(200);
    $('#hint_spot').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);},
	function() { 
	$('#spot').stop().fadeToggle(200); $('#orig').stop().fadeToggle(200);
	$('#hint_spot').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);});
//EXPLORE
$('#toggle_explore').hover(
	function() {
    $('#expl').stop().fadeToggle(200);$('#orig').stop().fadeToggle(200);
    $('#hint_expl').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);},
	function() { 
	$('#expl').stop().fadeToggle(200); $('#orig').stop().fadeToggle(200);
	$('#hint_expl').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);});
//USER
$('#toggle_user').hover(
	function() {
    $('#user').stop().fadeToggle(200);$('#orig').stop().fadeToggle(200);
    $('#hint_user').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);},
	function() { 
	$('#user').stop().fadeToggle(200); $('#orig').stop().fadeToggle(200);
	$('#hint_user').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);});

	// IMAGE FILL/RATIO ADJUST		
	var div = $( "#image" ).parent().width();
	var img = document.getElementById('image');
	//var div = $( ".container" ).width();
	var mult = 50;
	img.onload = function() {
	    if(img.clientHeight < img.clientWidth) {
	        img.style.height = div + mult + "px"; img.style.width = 'auto'; img.style.position = 'absolute';
	    	img.style.left = -((img.clientWidth+mult)/2 - div/2) + 'px';
	    	img.style.top = -((img.clientHeight+mult)/2 - div/2) + 'px';
	    }
	    else if(img.clientHeight > img.clientWidth) {
	        img.style.width = div + mult + "px"; img.style.height = 'auto'; img.style.position = 'absolute';
	    	img.style.top = -((img.clientHeight+mult)/2 - div/2) + 'px';
	    	img.style.left = -((img.clientWidth+mult)/2 - div/2) + 'px';
	    }
	};
	var divc = $( "#imagec" ).parent().width();
	var imgc = document.getElementById('imagec');
	//var divc = $( ".container" ).width();
	var multc = 10;
	imgc.onload = function() {
	    if(imgc.clientHeight < imgc.clientWidth) {
	        imgc.style.height = divc + multc + "px"; imgc.style.width = 'auto'; imgc.style.position = 'absolute';
	    	imgc.style.left = -((imgc.clientWidth+multc)/2 - divc/2) + 'px';
	    	imgc.style.top = -((imgc.clientHeight+multc)/2 - divc/2) + 'px';
	    }
	    else if(imgc.clientHeight > imgc.clientWidth) {
	        imgc.style.width = divc + multc + "px"; imgc.style.height = 'auto'; imgc.style.position = 'absolute';
	    	imgc.style.top = -((imgc.clientHeight+multc)/2 - divc/2) + 'px';
	    	imgc.style.left = -((imgc.clientWidth+multc)/2 - divc/2) + 'px';
	    }
	};
}());