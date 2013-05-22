module Frontend
  module Users
    class ProfilesController < ApplicationController
      layout 'user_profile'
      
      def show
        @user = ::User.find_by_slug(params[:username_slug])
      end

      def profile_edit

      end
    end
  end
end