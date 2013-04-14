# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->


  tags_list = $('[data-type = tag_list]')

  $('[data-type = tags_area]').on 'click', 'input', ->
    this_val = $(this).val()
    if $(this).is(':checked')
      if tags_list.val().length > 0
        tags_list.val(tags_list.val() + ', ' + this_val)
      else 
        tags_list.val(this_val)
    else
      exp = new RegExp("(,\\s)" + this_val + "$|" + this_val + "(,\\s)|(^" + this_val + "$)", "ig")
      tags_list.val(tags_list.val().replace(exp, ""))