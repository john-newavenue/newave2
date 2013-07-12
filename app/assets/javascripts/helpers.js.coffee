# $(document).ready( ()->

# nl2br = (text)->
#   (text + "").replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, "$1" + "<br>" + "$2")
  

# toggle_more_less = (objects = $('.toggle-more-less')) ->
#   objects.each (index, elem)->
#     data = $(elem).data()
#     text = $(elem).text()
#     truncate_length = data.truncateLength
#     truncate_char = "..."
#     if text.length > truncate_length
#       new_text = nl2br( text.substring(0, truncate_length - truncate_char.length) + truncate_char )
#       $(elem)
#         .html("""
#           <div class="truncated-text">
#             #{new_text}
#           </div>
#           <div class="full-text" style="display: none;">
#             #{text}
#           </div>
#         """)
#         .after("""
#           <div class="truncate-toggler">
#             <a class="truncate-toggle" onClick="javascript:$(this).parent().prev().find('.truncated-text, .full-text').toggle();">Show More</a>
#           </div>
#         """)

# toggle_more_less()

# )