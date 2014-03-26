# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.home = {}

window.home.dashboard = () ->
  $('#dashboard_nav li a').click (e)->
    $('#dashboard_nav li a').css('color', 'white')
    $('.curarium_dashboard').hide()
    $("#"+$(this).data('target')).show()
    $(this).css('color', 'red')
  undefined
