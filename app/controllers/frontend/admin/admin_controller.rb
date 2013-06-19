module Frontend
  module Admin

    class AdminController < AdminBaseController
      layout :resolve_layout

      # authorize_resource :class => false

      def index
      end

    end

  end
end