module Frontend
  module Projects
    class ProjectsController < FrontendBaseController
      layout :resolve_layout

      before_filter :authenticate_user!, only: [:new, :create, :destroy]
      #before_action :correct_user,   only: :destroy

      def index

      end

      def create # POST verb

        @project = Physical::Project::Project.new(project_params)
        if @project.save
          flash[:notice] = "Your project was created successfully!"
          @project.address = Physical::General::Address.new
          @project.save(:validate => false)

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

        # begin
        #   ActiveRecord::Base.transaction do
        #     @address = Physical::General::Address.create(address_params)
        #     @project = Physical::Project::Project.create(project_params)
            
        #     @project.address = @address
        #     @project.save
            
        #     Physical::Project::ProjectMember.create!(
        #       :user => current_user,
        #       :project => @project,
        #       :project_role => Physical::Project::ProjectRole.find_by_name('Lead')
        #     )
        #   end
        #   flash[:notice] = "Your project was created successfully!"
        #   # TODO: ping project managers about this project
        #   redirect_to user_profile_path(current_user.username)
        # rescue ActiveRecord::RecordInvalid => invalid
        #   flash[:alert] = "We found some errors in your submission. Please correct them."
        #   render 'new'
        #   return
        # end

      end

      def show
        @project = Physical::Project::Project.find(params[:id])
        @address = @project.address.decorate
      end

      def destroy

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

      private

        def project_params
          params.require(:project).permit(:title, :description,:address)
        end

        def address_params
          fields = [:line_1, :line_2, :city, :state, :zip_or_postal_code, :country, :other_details]
          params.require(:project).permit(:address => fields)[:address]
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
