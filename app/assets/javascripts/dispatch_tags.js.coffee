# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->

  tag_index = 0
  tags_pages = $('[data-type = tags_page]')
  tags_pages_size = tags_pages.size()

  if tags_pages_size > 0

    tags_pages.each (index)->
      $(this).hide() if index != 0
    $(tags_pages[0]).before("<a href='#' class='tag_link inline' data-type='tags_page_prev_btn'>...prev</a>")
    $(tags_pages[0]).before("<a href='#' class='tag_link inline' data-type='tags_page_next_btn'>next...</a>")


    $('[data-type = tags_page_prev_btn]').on 'click', ()->
      if tag_index > 0
        $(tags_pages[tag_index]).hide()
        tag_index-- 
        $(tags_pages[tag_index]).show()

    $('[data-type = tags_page_next_btn]').on 'click', ()->
      if tag_index < tags_pages_size - 1
        $(tags_pages[tag_index]).hide()
        tag_index++ 
        $(tags_pages[tag_index]).show()
