module Frontend
  module Dashboard
    class UserDashboardController < FrontendBaseController
      layout 'dashboards/user_dashboard'
      
      def profile
        @user = ::User.find_by_slug(params[:username_slug])
      end

      def profile_edit

      end
    end
  end
end