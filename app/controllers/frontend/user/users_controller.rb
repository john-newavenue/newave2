module Frontend
  module User
    class UsersController < FrontendBaseController
      def index
        
      end
      
      def profile
        @user = ::User.find_by_username(params[:username])
      end
    end
  end
end