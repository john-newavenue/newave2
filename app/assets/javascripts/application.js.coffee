$(document).ready( ()->

  window.theater = {}

  theater_modal = $('#theater-modal')

  position_and_size_theater = () ->
    # handles
    screen = theater_modal.find('.screen')
    screen_footer = theater_modal.find('.screen-footer')
    screen_sidebar = theater_modal.find('.screen-sidebar')
    screen_sidebar_footer = theater_modal.find('.screen-sidebar-footer')
    nav_button = theater_modal.find('.nav-button')
    nav_next = theater_modal.find('.next.nav-button')
    nav_previous = theater_modal.find('.previous.nav-button')
    # dimensions
    vph = document.documentElement.clientHeight
    vpw = document.documentElement.clientWidth
    console.debug vpw
    modal_width   = vpw*.95
    modal_height  = vph*.95
    footer_height = 38
    sidebar_width = 300
    screen_height = modal_height - footer_height
    screen_width  = modal_width - sidebar_width    
    nav_button_width = 100
    nav_button_height = 200
    # size and position the theater
    console.debug('bi')
    theater_modal.css
      width: modal_width + 'px'
      height: modal_height + 'px'
      top: vph*.05/2 + 'px'
      left: vpw*.05/2 + 'px'
    screen.css
      width: screen_width + 'px'
      height: screen_height + 'px'
      maxHeight: screen_height + 'px'
      left: 0
      top: 0
    screen_footer.css
      width: screen_width + 'px'
      height: footer_height + 'px'
      left: 0
      top: screen_height + 'px'
    screen_sidebar.css
      width: sidebar_width + 'px'
      height: screen_height + 'px'
      left: screen_width + 'px'
      top: 0
    screen_sidebar_footer.css
      width: sidebar_width + 'px'
      height: footer_height + 'px'
      left: screen_width + 'px'
      top: screen_height + 'px'
    nav_button.css
      top: screen_height/2 - nav_button_height/2 + 'px'
    nav_next.css
      left: screen_width  - nav_button_width + 'px'
    nav_previous.css
      left: 0

  window.position_and_size_theater = position_and_size_theater

  $('body').on('click','.display-theater', ()->
    # loading message
    theater_modal.find('.blank-loader').html('')
    theater_modal.find('.loading-container').html('Loading...')
    theater_modal.foundation 'reveal', 'open'
  )

  $(window).resize(() ->
    # resize theater if it's open
    position_and_size_theater() if $('#theater-modal.open').length == 1
  )

)