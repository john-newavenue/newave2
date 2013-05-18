module Frontend
  module Admin
    class InvitationsController < AdminBaseController

      before_filter :verify_admin

      def index
      end

      def new
        @invitation = Logical::Admin::Invitation.new()
      end

      def create
        @invitation = Logical::Admin::Invitation.new(params[:invitation] ? params[:invitation] : {} )
        if @invitation.valid?
          User.invite!(
            :email => @invitation.email,
            :username => /^[^@]+/.match(@invitation.email).to_s,
            :invited_by => current_user
          )
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
        @user = User.find_by_id(params[:id])
      end

      def update
        @user = User.find_by_id(params[:id])
      end

      def delete
        @user = User.find_by_id(params[:id])
      end

      def destroy
        @user = User.find_by_id(params[:id])
      end

    private

      def verify_admin
        forbidden unless current_user and (current_user.has_role?(:admin) or current_user.has_role?(:project_manager))
      end

      def invitation_params
        params.require(:invitation).permit(:email, :project_role)
      end

    end

  end
end