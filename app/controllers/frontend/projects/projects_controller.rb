module Frontend
  module Projects
    class ProjectsController < FrontendBaseController
      before_filter :authenticate_user!, only: [:new, :create, :destroy]
      #before_action :correct_user,   only: :destroy

      def index

      end

      def start

      end

      def create # POST verb

      end

      def destroy

      end

      def new # create new project form
        @project = Physical::Project::Project.create

        # if POST request and valid
        # create user project role as client
        # redirect to blank project

        # if POST request and invalid
        # show errors
      end
    end
  end
end
