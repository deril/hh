$(document).ready ->

  $(".accordion").accordion
    active: false,
    heightStyle: "content",
    # event: "mouseover",
    collapsible: true


  $(".accordion input[type=checkbox]").click ()->
    label = $(this).parent().find("label").text()
    tags = $("[data-type = tags_selected]").text()

    if $(this).is(':checked')
      tags = tags + ', '  if tags.length > 0
      tags = tags + label
    else
      expr = new RegExp("[,\\s]+" + label + "|^" + label + "[,\\s]*", "gi")
      tags = tags.replace(expr, '')

    $("[data-type = tags_selected]").html( tags )
