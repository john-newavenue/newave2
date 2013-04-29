module Frontend
  module Admin

    class ProjectTypeController < AdminBaseController

      def index
        @project_types = Admin::ProjectType.all
      end

      def edit

      end

    end

  end
end