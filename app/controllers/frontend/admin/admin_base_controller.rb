module Frontend
  module Admin

    class AdminBaseController < FrontendBaseController
      layout 'admin'
      
      before_filter :authenticate_user!
      before_action :authorize_user

      def index
      end

      private

        def authorize_user
          redirect_to root_url unless current_user and current_user.has_role? :admin
        end

      end

  end
end