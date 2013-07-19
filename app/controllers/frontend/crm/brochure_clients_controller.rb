module Frontend
  module Crm
    class BrochureClientsController < BrochuresController

      private

        def set_collection_category
          @category = Physical::General::Brochure::CLIENT_CATEGORY
        end

    end
  end
end 