# Some images were imported in a non-standard size (rectangles). Setting force_square on an item image container 
# will force the item image container to resize and become square using the width for the new height. The
# item image is the background image of the image container with attachment set to cover.
# See also frontend/albums/album_items/_show_image.html.erb
force_squares = ()->
  $('.force-square').each( (idx, elem) ->
    $(elem).css('height', $(elem).css('width'))
  )

$(document).ready( () ->
  $(window).resize( force_squares )
  $("#theater-modal").bind('opened', ()-> force_squares())
  force_squares()


)