module Frontend
  module Projects
    class ProjectItemsController < FrontendBaseController

      layout 'application'

      before_action :authenticate_user!, :only => [:new, :create, :destroy, :edit, :update]
      before_action :authorize_user, :except => [:new, :create]

      def index
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

        if can?(:update, @project_item.project) and @project_item.save
          @modal = 'new_save_album_item_success'
          @project_item.project.touch
        end

        respond_to do |format|
          format.js { render :partial => 'frontend/prompt_modal.js.coffee', :layout => false, :locals => { :modal => @modal } }
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
            forbidden unless can? :view, @project
          else
            forbidden unless can? :update, @project
          end
        end

        def project_item_params
          r = params.require(:project_item).permit(:body, :project_id, :project_item_assets_attributes => [:album_item_id])
          
          # convert some IDs from strings to integers
          if r.has_key?("project_item_assets_attributes") and r["project_item_assets_attributes"].has_key?("album_item_id")
            r["project_item_assets_attributes"]["album_item_id"] = r["project_item_assets_attributes"]["album_item_id"].to_i
          end
          r["project_id"] = r["project_id"].to_i
          
          # put singular nested asset into an array
          piaa = r["project_item_assets_attributes"]
          r["project_item_assets_attributes"] = [ piaa ] if piaa.is_a? Hash

          r
        end

    end
  end
end
