# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.section = {}

window.section.create = (user_form) ->
  $.getJSON(
    '../users.json'
    (users) ->
      d3.select(user_form.users_field).on(
        'keyup'
        () ->
          user_search = this.value.toLowerCase()
          d3.selectAll("li.user").remove()
          if user_search.length > 0
            ul = d3.select(user_form.user_list)
            selected_users = users.filter(
              (d) ->
                return d.name.toLowerCase().indexOf(user_search)>-1
            )
            ul = d3.select(user_form.user_list)
            ul.selectAll(".user").data(selected_users).enter().append('li').attr("class", "user").text(
              (d)->
                return d.name
            ).on(
              'click'
              () ->
                data = d3.select(this).data()[0]
                size = d3.select(user_form.user_target).selectAll('input').size()
                d3.select(user_form.user_target).append('div').attr("class", "user").text(
                  () ->
                    return data.name
                )
                d3.select(user_form.user_target).append('input').attr('type','hidden').attr(
                  "value"
                  () ->
                    return data.id
                ).attr("readonly", true).attr(
                  'name'
                  () ->
                    return "users["+parseInt(size)+"]"
                )
                d3.select(this).remove()
                users = users.filter (user)-> user.id != data.id
                 
                undefined
            )
           undefined
      )
  )
  undefined
