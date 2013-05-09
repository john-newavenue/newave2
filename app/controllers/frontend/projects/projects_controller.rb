module Frontend
  module Projects
    class ProjectsController < FrontendBaseController
      layout :resolve_layout

      before_filter :authenticate_user!, only: [:new, :create, :destroy]
      #before_action :correct_user,   only: :destroy

      def index

      end

      def create # POST verb
        @project = Physical::Project::Project.create(project_params)
        if @project.save
          
          # TODO: Probably remove rolify or limit its use...
          # Not easy to query "get all projects where this user is the client"
          #current_user.add_role :client, @project

          Physical::Project::ProjectMember.create!(
            :user => current_user,
            :project => @project,
            :project_role => Physical::Project::ProjectRole.find_by_name('Client')
          )

          flash[:notice] = "Your project was created successfully!"
          redirect_to user_profile_path(current_user.username)
        else
          flash[:alert] = "We found some errors in your submission. Please correct them."
          render 'new'
        end
      end

      def show
        @project = Physical::Project::Project.find(params[:id])
      end

      def destroy

      end

      def new # create new project form
        @no_sidebars = true
        @project = Physical::Project::Project.new

        # if POST request and valid
        # create user project role as client
        # redirect to blank project

        # if POST request and invalid
        # show errors
      end

      private

        def project_params
          params.require(:project).permit(:title, :description)
        end

        def resolve_layout
          case action_name
          when 'new'
            'one-column'
          else
            'project'
          end
        end

    end
  end
end
