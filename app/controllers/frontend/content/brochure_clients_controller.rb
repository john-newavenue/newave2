module Frontend
  module Content
    class BrochureClientsController < ::Frontend::Content::BrochuresController

      private

        def set_category
          @category = "Client"
        end

        def get_show_url_with_slug
          brochure_client_with_slug_path(:slug => @brochure.slug)
        end

    end
  end
end