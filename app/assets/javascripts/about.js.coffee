$(document).ready ->
  $('[data-type = hide_link]').on 'click', (event)->
    $(this).parent().find('[data-type = hide_content]').slideToggle("slow")
    event.preventDefault()
