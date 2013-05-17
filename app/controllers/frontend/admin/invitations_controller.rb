module Frontend
  module Admin
    class InvitationsController < AdminBaseController

      def index
      end

      def new
        @invitation = Logical::Admin::Invitation.new()
      end

      def create
        debugger
        @invitation = Logical::Admin::Invitation.new(params[:invitation])

        if @invitation.valid?
          User.invite!(:email => @invitation.email, :username => /^[^@]+/.match(@invitation.email).to_s )
          flash[:notice] = "Invitation sent."
          redirect_to admin_invitations_path
        else
          flash[:alert] = "There was an error with the invitation."
          render 'new'
        end
      end

      def show
        @user = User.find_by_id(params[:id])
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

      def invitation_params
        params.require(:invitation).permit(:email, :message, :project_role)
      end

      def verify_admin
        correct_role = current_user.has_role?(:admin) or current_user.has_role?(:project_manager)
        forbidden unless current_user and correct_role
      end
  end
end