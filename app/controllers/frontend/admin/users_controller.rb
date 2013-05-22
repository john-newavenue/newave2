module Frontend
  module Admin

    class UsersController < AdminBaseController
      # authorize_resource :class => false

      def index
        @users = UserDecorator.decorate_collection(User.active)
      end

      def edit

      end

    end

  end
end