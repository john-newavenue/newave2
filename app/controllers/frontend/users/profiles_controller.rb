module Frontend
  module Users
    class ProfilesController < ApplicationController
      layout 'dashboards/user_dashboard'
      
      def show
        @user = ::User.find_by_slug(params[:username_slug])
      end

      def profile_edit

      end
    end
  end
end