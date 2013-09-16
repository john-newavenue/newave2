module AlbumsHelper

  def new_images_upload_form(form_action_url, go_back_url)
    render(
      :template =>"frontend/albums/album_items/_new_images_upload_form.html.erb", :layout => nil,
      :locals => {
        :form_action_url => form_action_url,
        :go_back_url => go_back_url
      }
    ).to_s
  end 

  def album_edit_form(form_action_url, go_back_url, show_description_field = false, show_title_field = false)
    render(
      :template =>"frontend/albums/albums/_edit_form.html.erb", :layout => nil,
      :locals => {
        :show_title_field => show_title_field,
        :show_description_field => show_description_field,
        :form_action_url => form_action_url,
        :go_back_url => go_back_url
      }
    ).to_s
  end

  

end