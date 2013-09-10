module Frontend
  module Projects
    class ProjectAlbumController < ::Frontend::Albums::AlbumsController

      before_action :get_album, :except => [:new_clip_image, :save_clip_image]
      
      def new_clip_image
        @parent = Physical::Album::AlbumItem.find_by(:id => params[:album_item_id].to_i )
        @album_item = Physical::Album::AlbumItem.new(
          :parent => @parent,
          :root => @parent.root ? @parent.root : @parent
        )

        @modal = 'frontend/projects/project_album/new_clip_image_modal'
        if current_user.has_role?(:customer)
          @modal = 'frontend/projects/projects/prompt_create_first_project' if current_user.projects.count < 1
        elsif current_user.has_role?(:vendor)
          @modal = 'frontend/projects/projects/prompt_no_assigned_project' if current_user.projects.count < 1
        end

        respond_to do |format|
          format.js { render :partial => 'frontend/prompt_modal.js.coffee', :layout => false, :locals => { :modal => @modal } }
        end
      end

      def save_clip_image
        albums = Physical::Album::Album.where(:id => save_clip_image_params[:album_id])
        return not_found if albums.count == 0
        @album = albums.first
        if can?(:update, @album) and can?(:update, @album.parent)
          @album_image = @album.images.build(save_clip_image_params)
          @album_image.user = current_user

          if @album_image.save
            @modal = 'new_clip_image_success_modal'
            @album_image.reload
          else
            @modal - 'new_clip_image_error_modal'
          end

          respond_to do|format|
            format.js { render :partial => 'frontend/prompt_modal.js.coffee', :layout => false, :locals => { :modal => @modal } }
            format.html {}
          end

        else
          return forbidden
        end
        
      end

      def get_album
        projects = Physical::Project::Project.where(:id => params[:project_id])
        return not_found if projects.count == 0
        @album = projects.first.primary_album
      end

      private

        def save_clip_image_params 
          params.require(:album_item).permit(:parent_id, :album_id, :comment)
        end

    end
  end
end
