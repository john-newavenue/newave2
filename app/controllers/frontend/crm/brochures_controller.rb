module Frontend
  module Crm
    class BrochuresController < CrmBaseController

      before_action :set_collection_category, :get_collection_category
      before_action :set_brochure, :except => [:index]

      def index
        @collection = Physical::General::Brochure.where(:category => @category)
      end

      def show
      end

      def edit

      end

      def update
        @brochure.update_attributes(brochure_params)
        if @brochure.save
          flash[:notice] = "#{@brochure.title} updated."
          redirect_to crm_brochure_floorplans_path
        else
          flash[:warn] = "There were some errors."
          render 'edit'
        end
      end

      def delete
      end

      def create
      end

      def new
      end

      private

        def brochure_params
          params.require(:brochure).permit(:title, :category, :slug, :album_id, :short_description, :long_description, :cover_image, :area, :number_of_bed, :number_of_bath, :has_loft)
        end

        def set_collection_category
          raise 'Brochure collection type not set. Subclass this class and override this method with, for example, @type = 1'
        end

        def get_collection_category
          return not_found if @category.nil?
        end

        def set_brochure
          @brochure = Physical::General::Brochure.find_by(:id => params[:id])
          return not_found if @brochure == nil
        end

    end
  end
end