module Frontend
  module Content
    class BrochureFloorplanAlbumsController < ::Frontend::Albums::AlbumsController

    private

      def get_album
        brochures = Physical::General::Brochure.where(:category => 'Floor Plan', :id => params[:brochure_floorplan_id])
        return not_found if brochures.count == 0
        @album = brochures.first.album
      end

      def get_update_success_return_url
        brochure_floorplan_with_slug_path(:slug => @album.parent.slug)
      end

    end
  end
end