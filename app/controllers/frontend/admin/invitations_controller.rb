module Frontend
  module Admin
    class InvitationsController < AdminBaseController

      def index
        @invited_users = UserDecorator.decorate_collection(User.invited)
      end

      def new
        @invitation = Logical::Admin::Invitation.new()
      end

      def create
        @invitation = Logical::Admin::Invitation.new(params[:invitation] ? params[:invitation] : {} )
        if @invitation.valid?
          user = User.invite!(
            {
              :email => @invitation.email,
              :username => /^[^@]+/.match(@invitation.email).to_s + 3.times.to_a.map{rand(0..5)}.join
            }, current_user
          )
          project_role = Physical::Project::ProjectRole.find_by_id(params[:invitation][:project_role])
          user.add_role project_role.to_user_role
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

      def authorize_user
        forbidden unless current_user and (current_user.has_role?(:admin) or current_user.has_role?(:project_manager))
      end

      def invitation_params
        params.require(:invitation).permit(:email, :project_role)
      end

    end

  end
end