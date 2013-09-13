module Frontend
  module Crm
    class BrochuresController < CrmBaseController

      before_action :set_collection_category, :get_collection_category
      before_action :set_brochure, :except => [:index, :new, :create]

      def index
        @collection = Physical::General::Brochure.where(:category => @category).order('position ASC')
      end

      def show
      end

      def edit

      end

      def update
        @brochure.update_attributes(brochure_params)
        if @brochure.save
          flash[:notice] = "#{@brochure.title} updated."
          redirect_to brochure_index_path
        else
          flash[:warn] = "There were some errors."
          render 'edit'
        end
      end

      def delete
      end

      def create
        @brochure = Physical::General::Brochure.new(brochure_params)
        if @brochure.save
          flash[:notice] = "#{@brochure.title} created."
          redirect_to brochure_index_path
        else
          flash[:warn] = "There were some errors"
          render 'new'
        end
      end

      def new
        @brochure = Physical::General::Brochure.new
      end

      private

        def brochure_index_path
          case brochure_params[:category]
          when Physical::General::Brochure::CLIENT_CATEGORY
            crm_brochure_clients_path
          when Physical::General::Brochure::FLOORPLAN_CATEGORY
            crm_brochure_floorplans_path
          end
        end

        def brochure_params
          params.require(:brochure).permit(:title, :category, :slug, :album_id, :short_description, :long_description, :cover_image, :area, :number_of_bed, :number_of_bath, :has_loft, :position)
        end

        def set_collection_category
          raise 'Brochure collection type not set. Subclass this class and override this method with, for example, @category = 1'
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