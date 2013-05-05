module Frontend
  module Dashboard
    class UserDashboardController < FrontendBaseController
      layout 'dashboards/user_dashboard'
      
      def profile
        # TODO: slugify usernames - add a column for it and an on_create user action
        @user = ::User.find_by_slug(params[:username_slug])
      end
    end
  end
end