$(document).ready ->
  $('[data-type = hide_link]').on 'click', (event)->
    $(this).parent().find('[data-type = hide_content]').toggle()
    event.preventDefault();