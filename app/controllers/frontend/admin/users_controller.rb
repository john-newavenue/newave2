module Frontend
  module Admin

    class UsersController < AdminBaseController
      # authorize_resource :class => false

      def index
        @users = User.all
      end

      def edit

      end

    end

  end
end