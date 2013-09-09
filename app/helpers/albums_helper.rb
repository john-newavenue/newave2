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

end