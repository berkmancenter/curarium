# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.annotation = {}

window.annotation.tag_selector = ()->
  $('#tag_selector').change ()->
    div = $("<input type='text'class='annotation_tag' readonly='readonly' name='content[tags][]'>").val($(this).val())
    $(this).before(div)
    undefined
  undefined
