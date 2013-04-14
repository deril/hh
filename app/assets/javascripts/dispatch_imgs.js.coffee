# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready -> 

  # preview uploaded images
  $('[data-type = file_field]').on 'change', (evt)->
    files = evt.target.files
    i = 0
    while f = files[i]
      i++
      if f.type.match('image.*')
        reader = new FileReader()
        reader.onload = ((theFile)-> 
          (e)->
            img = ['<img class="thumb" src="' + e.target.result + '"',
                                      'title="' + escape(theFile.name) + '"',
                                      'width=250"/>'].join('')
            $('[data-type = upload_images]').html(img)
        )(f)
        reader.readAsDataURL(f)