module Frontend
  module Crm
    class BrochureClientsController < BrochuresController

      private

        def set_collection_category
          @category = "Client"
        end

    end
  end
end 