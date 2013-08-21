module Frontend
  module Projects
    class ProjectItemsController < FrontendBaseController

      clipped_album_item_id = nil

      layout 'application'

      before_action :authenticate_user!, :only => [:new, :create, :destroy, :edit, :update]
      before_action :authorize_user, :except => [:new, :create]

      def index
        @project = Physical::Project::Project.find_by(:id => params[:project_id])
        page = /\A([0-9]+)\z/.match(params[:page]) ? params[:page].to_i : 1
        @project_items = @project.items_readable_for(current_user).page(page)
        respond_to do |format|
          format.js
        end
      end

      def new 
        @project_item = Physical::Project::ProjectItem.new

        if params[:album_item_id]
          @album_item = Physical::Album::AlbumItem.find_by(:id => params[:album_item_id].to_i )
        end

        @modal = 'new_save_album_item'
        if current_user.has_role?(:customer)
          @modal = 'frontend/projects/projects/prompt_create_first_project' if current_user.projects.count < 1
        elsif current_user.has_role?(:vendor)
          @modal = 'frontend/projects/projects/prompt_no_assigned_project' if current_user.projects.count < 1
        end

        respond_to do |format|
          format.js { render :partial => 'frontend/prompt_modal.js.coffee', :layout => false, :locals => { :modal => @modal } }
        end
      end

      def create

        @modal = 'new_save_album_item'
        @project_item = Physical::Project::ProjectItem.new(project_item_params)
        @project_item.user = current_user


        # handle modal response for clipping pictures, which happen in modal dialogs
        if can?(:update, @project_item.project) and @project_item.save
          @project_item.reload
          if @project_item.category == "clipped_picture"
            @modal = 'new_save_album_item_success'
          end
        else
          @modal = 'new_save_album_item_error'
        end


        respond_to do |format|
          case @project_item.category
          when "clipped_picture"
            format.js { render :partial => 'frontend/prompt_modal.js.coffee', :layout => false, :locals => { :modal => @modal } }
          when "text"
            format.js { render :partial => 'frontend/projects/project_items/new_post.js.coffee', :layout => false, :locals => { :project_item => @project_item } }
          end

        end
      end

      def show
      end

      def edit
      end

      def update
      end

      def destroy
      end

      private

        def authorize_user
          case params[:action]
          when 'view', 'index'
            # forbidden unless can? :view, @project
          else
            forbidden unless can? :update, @project
          end
        end

        def project_item_params
          r = params.require(:project_item).permit(:body, :project_id, :project_item_assets_attributes => [ :album_item_attributes => [ :parent_id ] ])        
          
          # put things in arrays for rails nested attributes to digest
          if r["project_item_assets_attributes"] and r["project_item_assets_attributes"].is_a? Hash
            r["project_item_assets_attributes"] = [ r["project_item_assets_attributes"] ] 
          end
          
          r
        end

    end
  end
end
