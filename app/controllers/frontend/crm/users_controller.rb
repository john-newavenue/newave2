module Frontend
  module Crm

    class UsersController < CrmBaseController
      # authorize_resource :class => false

      before_action :get_user, :except => [:index]

      ITEMS_PER_PAGE = 24

      def index
        params = {"page" => 1}.merge( request.GET == nil ? {} : request.GET )
        @users_raw = User.active.page(params["page"]).per_page(ITEMS_PER_PAGE)
        @users = UserDecorator.decorate_collection( @users_raw )
      end

      def show 

      end

      def edit
      end

      def update
        @user.update_attributes(user_params)
        if @user.save
          flash[:notice] = "Changes saved."
          redirect_to edit_crm_user_path(@user)
        else
          flash[:alert] = 'Something went wrong.'
        render 'edit'

        end
      end

      private

      def get_user
        @user = User.find_by_id(params[:id])
      end

      def user_params
        params.require(:user).permit(:username, :email, :created_at, 
          :profile_attributes => [:first_name, :middle_name, :last_name, :avatar, :id]
        )
      end

    end

  end
end