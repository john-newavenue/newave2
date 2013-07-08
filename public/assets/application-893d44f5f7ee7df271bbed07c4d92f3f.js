(function() {
  $(document).ready(function() {
    var position_and_size_theater;

    window.theater = {};
    position_and_size_theater = function() {
      var footer_height, modal_height, modal_width, nav_button, nav_button_height, nav_button_width, nav_next, nav_previous, screen, screen_footer, screen_height, screen_sidebar, screen_sidebar_footer, screen_width, sidebar_width, theater_modal, vph, vpw;

      theater_modal = $('#theater-modal');
      screen = theater_modal.find('.screen');
      screen_footer = theater_modal.find('.screen-footer');
      screen_sidebar = theater_modal.find('.screen-sidebar');
      screen_sidebar_footer = theater_modal.find('.screen-sidebar-footer');
      nav_button = theater_modal.find('.nav-button');
      nav_next = theater_modal.find('.next.nav-button');
      nav_previous = theater_modal.find('.previous.nav-button');
      vph = document.documentElement.clientHeight;
      vpw = document.documentElement.clientWidth;
      modal_width = vpw * .95;
      modal_height = vph * .95;
      footer_height = 38;
      sidebar_width = 300;
      screen_height = modal_height - footer_height;
      screen_width = modal_width - sidebar_width;
      nav_button_width = 100;
      nav_button_height = 200;
      theater_modal.css({
        width: modal_width + 'px',
        height: modal_height + 'px',
        top: vph * .05 / 2 + 'px',
        left: vpw * .05 / 2 + 'px'
      });
      screen.css({
        width: screen_width + 'px',
        height: screen_height + 'px',
        maxHeight: screen_height + 'px',
        left: 0,
        top: 0
      });
      screen_footer.css({
        width: screen_width + 'px',
        height: footer_height + 'px',
        left: 0,
        top: screen_height + 'px'
      });
      screen_sidebar.css({
        width: sidebar_width + 'px',
        height: screen_height + 'px',
        left: screen_width + 'px',
        top: 0
      });
      screen_sidebar_footer.css({
        width: sidebar_width + 'px',
        height: footer_height + 'px',
        left: screen_width + 'px',
        top: screen_height + 'px'
      });
      nav_button.css({
        top: screen_height / 2 - nav_button_height / 2 + 'px'
      });
      nav_next.css({
        left: screen_width - nav_button_width + 'px'
      });
      return nav_previous.css({
        left: 0
      });
    };
    window.position_and_size_theater = position_and_size_theater;
    $('body').on('click', '.display-theater', function() {
      var theater_modal;

      theater_modal = $('#theater-modal');
      theater_modal.find('.blank-loader').html('');
      theater_modal.find('.loading-container').html('Loading...');
      return theater_modal.foundation('reveal', 'open');
    });
    $(window).resize(function() {
      if ($('#theater-modal.open').length === 1) {
        return position_and_size_theater();
      }
    });
    return $('body').on('click', '.display-prompt-modal', function() {
      var prompt_modal;

      prompt_modal = $('#prompt-modal');
      prompt_modal.find('.content_wrapper').html('Loading...');
      return prompt_modal.foundation('reveal', 'open');
    });
  });

}).call(this);
