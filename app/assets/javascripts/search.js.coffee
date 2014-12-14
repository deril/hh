$(document).ready ->

  $path = $("[data-type = autocomplete_path]").val()

  split = (val) ->
    val.split(/,\s+/)

  extractLast = (term) ->
    split(term).pop()

  $("[data-type = autocomplete]").bind("keydown", (event) ->
    if event.keyCode is $.ui.keyCode.TAB and $(this).data("ui-autocomplete").menu.active
      event.preventDefault()
      event.stopPropagation()
  ).autocomplete
    minLength: 2
    delay: 400
    "z-index": 9999
    source: $path
    search: ->
      term = extractLast(@value)
      if term.length < 2
        false
    focus: ->
      false
    select: (event, ui) ->
      terms = split(@value)
      terms.pop()
      terms.push(ui.item.value)
      if ui.item.value != ''
        terms.push("")
        @value = terms.join(", ")
      false
    response: (event, ui) ->
      unless ui.content.length
        ui.content.push { value: "", label: "No results found" }
      false
