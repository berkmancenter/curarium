
resizecontent = (winwidth, winheight) ->
#  GLOBAL_HOLDER_h = $(".GLOBAL_HOLDER").height()
#  GLOBAL_HOLDER_w = $(".GLOBAL_HOLDER").width()
#  spotlight_editor_w = $(".spotlight_editor td").width()

# Pretty much useless, since:
# a) it applies to screens <= 145px in height
# b) 'max-height' won't affect 'padding'
#  $('.bubble_menu .menu_piece').css(
#    "max-height": winheight-120
#    ,1000)

# Same as before
#  $('.bubble_menu .expand').css(
#    "max-height": winheight-150
#    ,1000)

# Can't find neither .spot_editor nor
# spotlight_editor_w ... Don't know
# what to do with this one.
#  $('.bubble_menu .spot_editor').css(
#    "width": spotlight_editor_w-10
#    ,1000)
  
# Percentages are a thing!
# Replaced with "max-width: 70%; max-height: 70%"
# in global.css.scss
#  #RECORD POPUP
#  $('.record_img .record').css(
#    "max-width": winwidth*0.70
#    "max-height": winheight*0.70
#    ,1000)
  
# Same as before
#  $('.record_img').css(
#    "width": $(".record_img .record").width()
#    "height": $(".record_img .record").height()
#    ,1000)

# Can't find record_popup, record_data,
# record_surr, spotlight_viewedit,
# last-child
#  $('.record_popup').css(
#    "width": $(".record_img .record").width()+320
#    "height": $(".record_img .record").height()+20
#    ,1000)
  
#  $('.record_data, .record_surr').css(
#    "height": $(".record_img .record").height()
#    ,1000)
  
#  $('.spotlight_viewedit').css(
#    "height": winheight-190
#    ,1000)
 
#  $(".GLOBAL_MENU .expandable img:last-child").css({"display":"none"})

#  Adjusted using a percentage width (33%)
#  Makes more sense to me this way
#  and it is based on CSS
#  Also, why .ABOUT? Shouldn't it be about_content?
#  #/ IF 5 TILES OR LESS
#  if GLOBAL_HOLDER_w <= 1100 
#    $(".ABOUT .right").css({"width":"200px"})
#  else
#    $(".ABOUT .right").css({"width":"420px"})
 

  #/ IF 4 TILES OR LESS (IPAD/SMALL SCREENS)
#  if GLOBAL_HOLDER_w <= 882
#    $(".GLOBAL_MENU .expandable .tools div").css({"width":"150px"})
#  else
#    $(".GLOBAL_MENU .expandable .tools div").css({"width":"200px"})
  

  #/ FOR FOOTER TO STICK TO BOTTOM
  # min-height: 100%
  # $(".GLOBAL_HOLDER").css({"min-height":winheight})


# What's wrong with "position: absolute; bottom: 0px
# as default? 
#  if GLOBAL_HOLDER_h < winheight
#    $(".FOOTER").css({"position":"absolute","bottom":"0"})
#  
#  if GLOBAL_HOLDER_h > winheight
#    $(".FOOTER").css({"position":"static"})
  

# hintbar_desc span font-size switched to 2em
# latestpost: 404
# explore_bar .album: "commented" (<!-- -->)
# bubble_menu bub_dis: the "display" is set to 'show', which
#   doesn't exist. If the screen width is < 882, it is
#   not displayed. why is that? Left like that, anyway
# .explore_bar .filter fixde with percentages
# about_content fixed earlier
  #/ ADJUST FONT SIZE TO FIT IN TABLE
#  if winwidth > 1540
#    $(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"28px"})
#    $(".latestpost").css({"font-size":"40px"})
#    $(".explore_bar .album, .bubble_menu .bub_dis").css({"display":"show"})
#    $(".explore_bar .filter").css({"width":"840px"})
#    $(".about_content .right .holder").css({"width":"420px"})
  
#  if winwidth < 1540
#    $(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"24px"})
#    $(".latestpost").css({"font-size":"38px"})
#    $(".bubble_menu .bub_dis").css({"display":"show"})
#    $(".explore_bar .album ").css({"display":"none"})
#    $(".explore_bar .filter").css({"width":"630px"})
#    $(".about_content .right .holder").css({"width":"420px"})
  
#  if winwidth < 1320
#    $(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"22px"})
#    $(".latestpost").css({"font-size":"35px"})
#    $(".bubble_menu .bub_dis").css({"display":"show"})
#    $(".explore_bar .album").css({"display":"none"})
#    $(".explore_bar .filter").css({"width":"420px"})
#    $(".about_content .right .holder").css({"width":"200px"})
  
#  if winwidth < 1100
#    $(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"21px"})
#    $(".latestpost").css({"font-size":"30px"})
#    $(".explore_bar .album, .bubble_menu .bub_dis").css({"display":"none"})
#    $(".explore_bar .filter").css({"width":"200px"})
#    $(".about_content .right .holder").css({"width":"200px"})
  
  if winwidth < 882
#    $(".INFO_BAR .expandable .hintbar_desc span").css({"font-size":"21px"})
#    $(".latestpost").css({"font-size":"30px"})
    $(".explore_bar .album, .bubble_menu .bub_dis").css({"display":"none"})
#    $(".about_content .right .holder").css({"width":"200px"})
  
#undefined





$(document).ready ()->
#  infobar_orginal = $("#hintbar_desc").html()
#  infobar_css = "#d2232a"
#  winheight = $(window).height()
#  winwidth = $(window).width()
#  resizecontent(winwidth, winheight)
  
  
# I could find no such thing as a pageid,
# therefore this 'highligh' always turns
# out to work on ".tools .undefined"
#  if $(".toggle_explore").length > 0
#    highlight = ".tools ."+$('#pageid').attr('class')
#    alert(highlight)
#    $(highlight + " a").css({'color': infobar_css,'font-weight': "bold"})
#    $(highlight + " img:first-child").css({'display': "none"})
#    $(highlight + " img:last-child").css({'display': "show"})  
#    
#    $(highlight).hover(()->
#      $(this).noop()
#    ,()->
#      $(this).noop()
#    )
  
  
#  # MENU TOGGLE
#  $('.toggle_curarium,.toggle_user').hover(()->
#    $(this).find(".dropdown_menu").stop().show('fadein')
#  ,()->
#    $(this).find(".dropdown_menu").stop().hide('fadeout')
#  )
    
#  $('.toggle_collections, .toggle_spotlights, .toggle_explore, .toggle_user').hover(()->
#   $(this).find("img").stop().fadeToggle(200)
#   $(this).find("a").stop().animate({"color":infobar_css},200)
#  ,()->
#    $(this).find("img").stop().fadeToggle(200)
#    $(this).find("a").stop().animate({"color":"black"},200)
#  )
  
  
  
#  #COLLECTIONS
#  $('.toggle_collections').hover(()->
#    $('#coll').stop().fadeToggle(200);$('#orig').stop().fadeToggle(200)
#    $('#hint_coll').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200)
#  ()->
#    $('#coll').stop().fadeToggle(200); $('#orig').stop().fadeToggle(200)
#    $('#hint_coll').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200)
#  )
  
#  #SPOTLIGHTS
#  $('.toggle_spotlights').hover(()->
#    $('#spot').stop().fadeToggle(200);$('#orig').stop().fadeToggle(200)
#    $('#hint_spot').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200)
#  ,()->
#    $('#spot').stop().fadeToggle(200); $('#orig').stop().fadeToggle(200)
#    $('#hint_spot').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200)
#  )
  
#  #EXPLORE
#  $('.toggle_explore').hover(()->
#      $('#expl').stop().fadeToggle(200);$('#orig').stop().fadeToggle(200)
#      $('#hint_expl').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200)
#    ,()->
#      $('#expl').stop().fadeToggle(200); $('#orig').stop().fadeToggle(200)
#      $('#hint_expl').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200)
#    )

#  #USER
#  $('.toggle_user').hover(()->
#      $('#user').stop().fadeToggle(200);$('#orig').stop().fadeToggle(200)
#      $('#hint_user').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200)
#    ,()->
#      $('#user').stop().fadeToggle(200); $('#orig').stop().fadeToggle(200)
#      $('#hint_user').stop().fadeToggle(200);$('#hint_orig').stop().fadeToggle(200)
#    )


#  #ABOUT PAGES SIDE MENU#
#  $('.cont_vocab span, .stalking_menu div').hover(()->
#    $(this).css(
#      'cursor': 'pointer'
#      'text-decoration': 'underline'
#    )
#  ,()->
#    $(this).css(
#      'cursor': 'pointer'
#      'text-decoration': 'none'
#    )
#  )
  
#  #ABOUT PAGES MENU SCROLL TO#
#  $(".stalking_menu div").click ()->
#    scrollto = "." + $(this).attr('class')
#    $('html, body').animate({scrollTop: $('.about_content .expandable').find(scrollto).offset().top}, 500)
  
#  #ABOUT PAGES VOCAB SCROLL TO#
  $(".cont_vocab span").click ()->
    scrollto = "." + $(this).attr('class')
#    $('html, body').animate({scrollTop: $('.howitem').find(scrollto).offset().top}, 500)
    $('.howitem span').css({"text-decoration": "none","color":"black"},1000)
    $('.howitem').find(scrollto).css({"color":"#d2232a","text-decoration":"underline", "font-weight": "bold"},1000)
    
  # SUB-MENU TOGGLE
#  $('.layout_icon').hover(()->
#      idvalue = $(this).attr('id')
#      $(this).find("img").stop().fadeToggle(200)
#      $(this).stop().css({"border":"1px solid"+infobar_css},200)
#      $('.layout_desc').stop().html(idvalue)
#    ,()->
#      $(this).find("img").stop().fadeToggle(200)
#      $(this).stop().css({"border":"1px solid black"},200)
#      $('.layout_desc').stop().html("Layout:")
#  )
  
  
#  # EXPLORE-PAGE
#  $('.controls_toggle, .navigate, .orderby img').hover(()->
#      $(this).css({'cursor': 'pointer'})
#    ,()->
#      $(this).css({'cursor': 'pointer'})
#  )
  
#  $('.controls_toggle').click(
#    ()->
#      $('.slider_bar').stop().slideToggle(200)
#      $(this).find("img").stop().fadeToggle(200)
#    ,()->
#      $('.slider_bar').stop().slideToggle(200)
#      $(this).find("img").stop().fadeToggle(200)
#  )
  
#  # RECORDS-PAGE
#  $('.bub_menu, .record_popup .add_to_tray').click(()->
#      $(this).find(".expand").stop().slideToggle(200)
#      $(this).find(".button img").stop().fadeToggle(200)
#    ()->
#      $(this).find(".expand").stop().slideToggle(200)
#      $(this).find(".button img").stop().fadeToggle(200)
#  )
   
#  $('.orderby .ordering_list').click(()->
#      $('.expand_orderby').stop().slideToggle(200)
#   ,()->
#    $('.expand_orderby').stop().slideToggle(200)
#  )
#  undefined

#$(window).resize ()->
#  winheight = $(window).height()
#  winwidth = $(window).width()
#  resizecontent(winwidth, winheight)
