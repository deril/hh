# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->

  seeking_file = $('[data-type = file_field]')

  if seeking_file.size() > 0
    seeking_file.hide()

    # preview uploaded images
    seeking_file.on 'change', (evt)->
      files = evt.target.files
      i = 0
      while f = files[i]
        i++
        if f.type.match('image.*')
          reader = new FileReader()
          reader.onload = ((theFile)->
            (e)->
              img = ['<img class="view_img" data-type="select_image"',
                          'src="' + e.target.result + '"',
                          'title="' + escape(theFile.name) + '"',
                          'width=250"/>'].join('')
              $('[data-type = upload_images]').html(img)
          )(f)
          reader.readAsDataURL(f)

    # image changing
    $('[data-type = select_image]').on 'click', ()->
      seeking_file.click()
