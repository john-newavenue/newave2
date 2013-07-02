# theater handle
theater_modal = $('#theater-modal')

# populate the theater
theater_modal.find('.content-wrapper').html "<%= escape_javascript(render :partial => 'show_theater') %>"

position_and_size_theater()