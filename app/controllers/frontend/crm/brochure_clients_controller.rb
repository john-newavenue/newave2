module Frontend
  module Crm
    class BrochureFloorplansController < BrochuresController

      private

        def set_collection_category
          @category = Physical::General::Brochure::FLOORPLAN_CATEGORY
        end

    end
  end
end 