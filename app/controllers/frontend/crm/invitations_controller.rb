module Frontend
  module Crm
    class InvitationsController < CrmBaseController

      def index
        @invited_users = UserDecorator.decorate_collection(User.invited)
      end

      def new
        @invitation = Logical::Admin::Invitation.new()
      end

      def create

        # debugger

        @invitation = Logical::Admin::Invitation.new(invitation_params)

        if @invitation.valid?
          @invitation.send!(current_user)
          flash[:notice] = "Invitation sent."
          redirect_to crm_invitations_path
        else
          debugger
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

      def authorize_user
        forbidden unless current_user and (current_user.has_role?(:admin) or current_user.has_role?(:project_manager))
      end

      def invitation_params
        params.require(:invitation).permit(:first_name, :last_name, :username, :email, :project_role, :message, :vendor, :is_new_vendor, :new_vendor_name, :new_vendor_type)
      end

    end

  end
end