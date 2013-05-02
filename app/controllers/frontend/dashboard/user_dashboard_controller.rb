module Frontend
  module Dashboard
    class UserDashboardController < FrontendBaseController
      layout 'dashboards/user_dashboard'
      
      def profile
        # TODO: slugify usernames - add a column for it and an on_create user action
        @user = ::User.find_by_username(params[:username])
      end
    end
  end
end