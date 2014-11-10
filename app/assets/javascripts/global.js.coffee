
$(document).ready ()->
  
#  #ABOUT PAGES VOCAB SCROLL TO#
  $(".cont_vocab span").click ()->
    scrollto = "." + $(this).attr('class')
#    $('html, body').animate({scrollTop: $('.howitem').find(scrollto).offset().top}, 500)
    $('.howitem span').css({"text-decoration": "none","color":"black"},1000)
    $('.howitem').find(scrollto).css({"color":"#d2232a","text-decoration":"underline", "font-weight": "bold"},1000)
    
