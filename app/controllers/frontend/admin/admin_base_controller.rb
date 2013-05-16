module Frontend
  module Admin

    class AdminBaseController < FrontendBaseController
      layout 'admin'
      before_filter :verify_admin

      def index
      end

      private

        # TODO: I don't think this does anything. Kill AdminAbility/
        def current_ability

          @current_ability ||= AdminAbility.new(current_user)
        end

        def verify_admin
          redirect_to root_url unless current_user and current_user.has_role? :admin
        end

      end

  end
end