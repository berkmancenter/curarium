
function resizecontent (winwidth, winheight){
var GLOBAL_HOLDER_h = $(".GLOBAL_HOLDER").height();
var GLOBAL_HOLDER_w = $(".GLOBAL_HOLDER").width();


console.log(GLOBAL_HOLDER_w);
/// IF 5 TILES OR LESS
if(GLOBAL_HOLDER_w <= 1100){
	$(".ABOUT .right").css({"width":"200px"});
	}else{
	$(".ABOUT .right").css({"width":"420px"});
	};
/// IF 4 TILES OR LESS (IPAD/SMALL SCREENS)
if(GLOBAL_HOLDER_w <= 882){
	$(".GLOBAL_MENU .expandable .tools div").css({"width":"150px"});
	}else{
	$(".GLOBAL_MENU .expandable .tools div").css({"width":"200px"});
	};
	
	
/// FOR FOOTER TO STICK TO BOTTOM
$(".GLOBAL_HOLDER").css({"min-height":winheight});
if(GLOBAL_HOLDER_h < winheight){$(".FOOTER").css({"position":"absolute","bottom":"0"});}
if(GLOBAL_HOLDER_h > winheight){$(".FOOTER").css({"position":"static"});}


/// ADJUST FONT SIZE TO FIT IN TABLE
	if(winwidth > 1540){
	$(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"28px"});
	$(".latestpost").css({"font-size":"40px"});
	}	
	if(winwidth <= 1540){
	$(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"24px"});
	$(".latestpost").css({"font-size":"38px"});
	}
	if(winwidth <= 1320){
	$(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"22px"});
	$(".latestpost").css({"font-size":"35px"});
	};
	if(winwidth <= 1100){
	$(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"21px"});
	$(".latestpost").css({"font-size":"30px"});
	};
	if(winwidth <= 882){
	$(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"21px"});
	$(".latestpost").css({"font-size":"30px"});
	};

}


$(window).resize(function(){
var winheight = $(window).height();
var winwidth = $(window).width();
resizecontent (winwidth, winheight);

});


$(document).ready(function() {
var infobar_orginal = $("#hintbar_desc").html();
var infobar_css = "#d2232a";
var winheight = $(window).height();
var winwidth = $(window).width();
resizecontent (winwidth, winheight);



// MENU TOGGLE CURARIUM
$('.toggle_curarium').hover(
	function() {
	$('#dropdown_menu', this).stop().show('blind');
	$("#about_page #about_links").stop().fadeToggle(200);
	if ($('#cura').length > 0) {	
	$("#cura").stop().fadeToggle(200).css({"color":infobar_css},200);$('#orig').stop().fadeToggle(200);
	}},
    function() {   
    $('#dropdown_menu', this).stop().hide('blind');
    $("#about_page #about_links").stop().fadeToggle(200);
	if ($('#cura').length > 0) {	
	$("#cura").stop().fadeToggle(200).css({"color":infobar_css},200);$('#orig').stop().fadeToggle(200);
	}});
// MENU TOGGLE USER
$('.toggle_user').hover(
	function() {
	$('#dropdown_menu', this).stop().show('blind');},
    function() {   
    $('#dropdown_menu', this).stop().hide('blind');});

//COLLECTIONS
$('.toggle_collections').hover(
	function() {
    $('#coll').stop().fadeToggle(200);$('#orig').stop().fadeToggle(200);
    $('#hint_coll').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);},
	function() { 
	$('#coll').stop().fadeToggle(200); $('#orig').stop().fadeToggle(200);
	$('#hint_coll').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);});
//SPOTLIGHTS
$('.toggle_spotlights').hover(
	function() {
    $('#spot').stop().fadeToggle(200);$('#orig').stop().fadeToggle(200);
    $('#hint_spot').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);},
	function() { 
	$('#spot').stop().fadeToggle(200); $('#orig').stop().fadeToggle(200);
	$('#hint_spot').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);});
//EXPLORE
$('.toggle_explore').hover(
	function() {
    $('#expl').stop().fadeToggle(200);$('#orig').stop().fadeToggle(200);
    $('#hint_expl').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);},
	function() { 
	$('#expl').stop().fadeToggle(200); $('#orig').stop().fadeToggle(200);
	$('#hint_expl').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);});
//USER
$('.toggle_user').hover(
	function() {
    $('#user').stop().fadeToggle(200);$('#orig').stop().fadeToggle(200);
    $('#hint_user').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);},
	function() { 
	$('#user').stop().fadeToggle(200); $('#orig').stop().fadeToggle(200);
	$('#hint_user').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200);});

//ABOUT PAGE//
var highlight = 
$('#vocab span, .ABOUT .left span').hover(
	function() {$(this).css({'cursor': 'pointer','text-decoration': 'underline'});},
	function() {$(this).css({'cursor': 'pointer','text-decoration': 'none'});});
	
$(".ABOUT .left #what").click(function() {
    $('html, body').animate({scrollTop: $(".ABOUT .expandable #what").offset().top}, 1000);});
$(".ABOUT .left #vocab").click(function() {
    $('html, body').animate({scrollTop: $(".ABOUT .expandable #vocab").offset().top}, 1000);});
$(".ABOUT .left #how").click(function() {
    $('html, body').animate({scrollTop: $(".ABOUT .expandable #how").offset().top}, 1000);});
$(".ABOUT .left #contact").click(function() {
    $('html, body').animate({scrollTop: $(".ABOUT .expandable #contact").offset().top}, 1000);});
	
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
$('.toggle_collections, .toggle_spotlights, .toggle_explore, .toggle_user').hover(
	function() {
    $(this).find("img").stop().fadeToggle(200);
    $(this).find("a").stop().animate({"color":infobar_css},200);
    $("#about_page #about_links").stop().fadeToggle(200);
	},
	function() { 
	$(this).find("img").stop().fadeToggle(200);
	$(this).find("a").stop().animate({"color":"black"},200);
	$("#about_page #about_links").stop().fadeToggle(200);
	});

// SUB-MENU
$('.layout_icon').hover(
	function() {
	var idvalue = $(this).attr('id');
    $(this).find("img").stop().fadeToggle(200);
    $(this).stop().css({"border":"1px solid"+infobar_css},200);
    $('.layout_desc').stop().html(idvalue);
	},
	function() { 
	$(this).find("img").stop().fadeToggle(200);
	$(this).stop().css({"border":"1px solid black"},200);
	$('.layout_desc').stop().html("Layout:");
	});
// USER-PAGE

      
    $(document).scrollTop($(document)[0].scrollHeight);

    var Height = 600;

    $(document).scroll(function(){
        if ($(document).scrollTop() == 0){
            $('#menu_float').stop().animate({"margin":"-15px 0 0 0"},{duration: 300,easing: 'easeInOutCirc'});
            //alert('up');

        }else{
            //$('#menu_float').css({"margin":"-300px 0 0 0"});
            $('#menu_float').stop().animate({"margin":"-350px 0 0 0"},{duration: 300,easing: 'easeInOutCirc'});
            //alert('down');
        }
    });


	
	
}());