module Frontend
  module Crm

    class CrmBaseController < FrontendBaseController
      layout :resolve_layout
      
      before_filter :authenticate_user!
      before_action :authorize_user

      private

        def authorize_user
          redirect_to root_url unless current_user and (current_user.has_role? :admin or current_user.has_role? :project_manager)
        end

        def resolve_layout
          case action_name
          when 'index'
            'one-column'
          else
            'admin'
          end
        end

    end

  end
end