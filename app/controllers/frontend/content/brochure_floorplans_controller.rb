module Frontend
  module Content
    class BrochureFloorplansController < ::Frontend::Content::BrochuresController

      private

        def set_category
          @category = "Floor Plan"
        end

        def get_show_url_with_slug
          brochure_floorplan_with_slug_path(:slug => @brochure.slug)
        end

    end
  end
end