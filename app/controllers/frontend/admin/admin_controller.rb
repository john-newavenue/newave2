module Frontend
  module Admin

    class AdminController < AdminBaseController
      authorize_resource :class => false

      def index
        # raise 'asdf'
      end

    end

  end
end