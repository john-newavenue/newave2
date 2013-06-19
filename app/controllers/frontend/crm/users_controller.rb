module Frontend
  module Crm

    class UsersController < CrmBaseController
      # authorize_resource :class => false

      def index
        @users = UserDecorator.decorate_collection(User.active)
      end

      def show 
        @user = User.find_by_id(params[:id])
      end

    end

  end
end