# prompt handle
prompt_modal = $('#prompt-modal')
prompt_content = prompt_modal.find('.content-wrapper')

# render
prompt_content.html("<%= escape_javascript(render :partial => modal) %>")