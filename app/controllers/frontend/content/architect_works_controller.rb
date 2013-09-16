module Frontend
  module Content
    class ArchitectWorksController < Frontend::Albums::AlbumsController

      layout :resolve_layout
      before_action :get_album
      before_action :authorize_user, :only => [:edit, :update, :upload_images]
      protect_from_forgery :except => [:upload_images]

      private

        def compile_return_params(album_item)
          {
            'url' => album_item.get_attachment2(:original),
            'name' =>  album_item.attachment_file_name,
            'thumbnail_url' => album_item.get_attachment2(:small_square)
            # 'item_url'
            # 'item_id'
          }
        end

        def get_update_success_return_url
          return featured_architect_with_slug_path(:slug => @profile.user.slug)
        end

        def get_album
          # only vendors can have featured work
          profile = Physical::User::UserProfile.includes(:user, :featured_work_album).find_by(:id => params[:featured_architect_id])
          # return not_found unless (profile and profile.user.has_role? :vendor)
          # debugger  
          @profile = profile
          @album = profile.featured_work_album
        end

    end
  end
end