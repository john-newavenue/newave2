module Frontend
  module Admin
    class InvitationsController < AdminBaseController

      def index
      end

      def new
        @invitation
      end

      def create
        # verify project role
        valid_roles = Physical::Project::ProjectRole.all.map { |r| r.id }
        valid_roles.include? params[:invitation][:project_role].to_i
        debugger

        render 'show'

      end

      def show
      end

      def edit
      end

      def update
      end

      def delete
      end

      def destroy
      end

    end

    private

      def verify_admin
        correct_role = current_user.has_role?(:admin) or current_user.has_role?(:project_manager)
        forbidden unless current_user and correct_role
      end
  end
end