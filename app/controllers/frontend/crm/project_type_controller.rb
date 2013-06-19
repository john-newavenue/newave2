module Frontend
  module Crm

    class ProjectTypeController < CrmBaseController

      def index
        @project_types = Admin::ProjectType.all
      end

      def edit

      end

    end

  end
end