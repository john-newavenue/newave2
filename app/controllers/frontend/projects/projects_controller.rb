module Frontend
  module Projects
    class ProjectsController < FrontendBaseController
      layout :resolve_layout

      before_filter :authenticate_user!, :only => [:new, :create, :destroy, :edit, :update]
      before_action :authorize_user, :only => [:edit, :update]

      def index

      end

      def new # create new project form
        @project = Physical::Project::Project.new
        @address = Physical::General::Address.new

        # if POST request and valid
        # create user project role as client
        # redirect to blank project

        # if POST request and invalid
        # show errors
      end

      def create # POST verb

        @project = Physical::Project::Project.new(project_params)
        if @project.save
          flash[:notice] = "Your project was created successfully!"
          
          # assign some roles and tags
          if current_user.has_role? :customer
            @project.add_user_as_client(current_user)
            # TODO: tag project as lead, feed to activities
          end

          redirect_to project_path(@project)
        else
          flash[:alert] = "We found some errors in your submission. Please correct them."
          render 'new'
        end

      end

      def show
        @project = Physical::Project::Project.find(params[:id])
        @address = @project.address.decorate
      end

      def edit
        @project = Physical::Project::Project.find(params[:id])
      end

      def update
        @project = Physical::Project::Project.find(params[:id])
        @project.update_attributes(project_params)
        if @project.save
          flash[:notice] = "Your project was updated successfully."
          redirect_to project_path(@project)
        else
          flash[:alert] = "Something went wrong. Please fix any errors."
          render 'edit'
        end
      end

      def destroy

      end


      private

        def project_params
          params.require(:project).permit(:title, :description, 
            :address_attributes => [:line_1, :line_2, :city, :state, :zip_or_postal_code, 
              :country, :other_details]
          )
        end

        def authorize_user
          @project = Physical::Project::Project.find_by_id(params[:id])
          forbidden unless can? :update, @project
        end

        def resolve_layout
          case action_name
          when 'new', 'create'
            'one-column'
          else
            'project'
          end
        end

    end
  end
end
