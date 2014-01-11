$(document).ready ->

  $path = $("[data-type = autocomplete_path]").val()

  split = (val) ->
    val.split /,\s*/

  extractLast = (term) ->
    split(term).pop()

  $("[data-type = autocomplete]").bind("keydown", (event) ->
    if event.keyCode is $.ui.keyCode.TAB and $(this).data("ui-autocomplete").menu.active
      event.preventDefault()
  ).autocomplete
    minLength: 2
    delay: 400
    "z-index": 9999
    source: $path
    focus: ->
      # prevent value inserted on focus
      false
    select: (event, ui) ->
      terms = split(@value)
      terms.pop()
      terms.push(ui.item.value)
      terms.push("")
      @value = terms.join(", ")
      false
