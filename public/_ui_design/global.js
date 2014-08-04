
function resizecontent (winwidth, winheight){
var GLOBAL_HOLDER_h = $(".GLOBAL_HOLDER").height();
var GLOBAL_HOLDER_w = $(".GLOBAL_HOLDER").width();
var spotlight_editor_w = $(".spotlight_editor td").width();

$('.bubble_menu .menu_piece').css({"max-height": winheight-120},1000);
$('.bubble_menu .expand').css({"max-height": winheight-150},1000);
$('.bubble_menu .spot_editor').css({"width": spotlight_editor_w-10},1000);

//RECORD POPUP
$('.record_img .record').css({"max-width": winwidth*0.70, "max-height": winheight*0.70},1000);
$('.record_img').css({"width": $(".record_img .record").width(), "height": $(".record_img .record").height()},1000);
$('.record_popup').css({"width": $(".record_img .record").width()+320, "height": $(".record_img .record").height()+20},1000);
$('.record_data, .record_surr').css({"height": $(".record_img .record").height()},1000);

$('.spotlight_viewedit').css({"height": winheight-190},1000);






$(".GLOBAL_MENU .expandable img:last-child").css({"display":"none"});
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
	$(".explore_bar .album, .bubble_menu .bub_dis").css({"display":"show"});
	$(".explore_bar .filter").css({"width":"840px"});
	$(".about_content .right .holder").css({"width":"420px"});
	}	
	if(winwidth < 1540){
	$(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"24px"});
	$(".latestpost").css({"font-size":"38px"});
	$(".bubble_menu .bub_dis").css({"display":"show"});
	$(".explore_bar .album ").css({"display":"none"});
	$(".explore_bar .filter").css({"width":"630px"});
	$(".about_content .right .holder").css({"width":"420px"});
	}
	if(winwidth < 1320){
	$(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"22px"});
	$(".latestpost").css({"font-size":"35px"});
	$(".bubble_menu .bub_dis").css({"display":"show"});
	$(".explore_bar .album").css({"display":"none"});
	$(".explore_bar .filter").css({"width":"420px"});
	$(".about_content .right .holder").css({"width":"200px"});
	};
	if(winwidth < 1100){
	$(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"21px"});
	$(".latestpost").css({"font-size":"30px"});
	$(".explore_bar .album, .bubble_menu .bub_dis").css({"display":"none"});
	$(".explore_bar .filter").css({"width":"200px"});
	$(".about_content .right .holder").css({"width":"200px"});
	};
	if(winwidth < 882){
	$(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"21px"});
	$(".latestpost").css({"font-size":"30px"});
	$(".explore_bar .album, .bubble_menu .bub_dis").css({"display":"none"});
	$(".about_content .right .holder").css({"width":"200px"});

	};

}





$(document).ready(function() {
var infobar_orginal = $("#hintbar_desc").html();
var infobar_css = "#d2232a";
var winheight = $(window).height();
var winwidth = $(window).width();
resizecontent (winwidth, winheight);



if($(".toggle_explore").length > 0) {
	var highlight = ".tools ."+$('#pageid').attr('class');
   $(highlight + " a").css({'color': infobar_css,'font-weight': "bold"});
   $(highlight + " img:first-child").css({'display': "none"});
   $(highlight + " img:last-child").css({'display': "show"});

	$(highlight).hover(
	function() {
    $(this).noop();

	},
	function() { 
	$(this).noop();
	});
}


// MENU TOGGLE
$('.toggle_curarium,.toggle_user').hover(
	function() {
	$(this).find(".dropdown_menu").stop().show('fadein');},
    function() {
    $(this).find(".dropdown_menu").stop().hide('fadeout');});  
      
$('.toggle_collections, .toggle_spotlights, .toggle_explore, .toggle_user').hover(
	function() {
    $(this).find("img").stop().fadeToggle(200);
    $(this).find("a").stop().animate({"color":infobar_css},200);
	},
	function() { 
	$(this).find("img").stop().fadeToggle(200);
	$(this).find("a").stop().animate({"color":"black"},200);
	});


	
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


//ABOUT PAGES SIDE MENU//
$('.cont_vocab span, .stalking_menu div').hover(
	function() {$(this).css({'cursor': 'pointer','text-decoration': 'underline'});},
	function() {$(this).css({'cursor': 'pointer','text-decoration': 'none'});});
//ABOUT PAGES MENU SCROLL TO//
$(".stalking_menu div").click(function() {
	var scrollto = "." + $(this).attr('class');
    $('html, body').animate({scrollTop: $('.about_content .expandable').find(scrollto).offset().top}, 500);
    });
//ABOUT PAGES VOCAB SCROLL TO//
$(".cont_vocab span").click(function() {
	var scrollto = "." + $(this).attr('class');
    $('html, body').animate({scrollTop: $('.howitem').find(scrollto).offset().top}, 500);
	$('.howitem span').css({"text-decoration": "none","color":"black"},1000);
   	$('.howitem').find(scrollto).css({"color":infobar_css,"text-decoration":"underline", "font-weight": "bold"},1000);   
    });
// SUB-MENU TOGGLE
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
	

// EXPLORE-PAGE
$('.controls_toggle, .navigate, .orderby img').hover(
	function() {$(this).css({'cursor': 'pointer'});},
	function() {$(this).css({'cursor': 'pointer'});});
$('.controls_toggle').click(
	function() {
    $('.slider_bar').stop().slideToggle(200);
   $(this).find("img").stop().fadeToggle(200);
   },
	function() { 
	$('.slider_bar').stop().slideToggle(200);
	$(this).find("img").stop().fadeToggle(200);
	});
	
// RECORDS-PAGE
$('.bub_menu, .record_popup .add_to_tray').click(function() {
		$(this).find(".expand").stop().slideToggle(200);
		$(this).find(".button img").stop().fadeToggle(200);},
	function() {
		$(this).find(".expand").stop().slideToggle(200);
		$(this).find(".button img").stop().fadeToggle(200);});

// RECORDS-PAGE
//$('.orderby .ordering_list').click(function() { 
	//alert('test');
	//	$('.right .orderby .expand').stop().slideToggle(200);
	//	},
	//function() {
	//	//$('.right .orderby .expand').stop().slideToggle(200);
	//	});

$('.orderby .ordering_list').click(function() {
		$('.expand_orderby').stop().slideToggle(200);
		},
	function() {
		$('.expand_orderby').stop().slideToggle(200);
		});


}());

$(window).resize(function(){
var winheight = $(window).height();
var winwidth = $(window).width();
resizecontent (winwidth, winheight);

});