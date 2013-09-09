module Frontend
  module Content
    class BrochuresController < ApplicationController

      layout :resolve_layout
      before_action :set_category
      before_action :get_brochure, :except => [:index, :new, :create]
      before_action :authorize_user, :only => [:edit, :update, :create, :delete]

      def index
        @brochures = Physical::General::Brochure.where(:category => @category).order('position ASC')
      end

      def new
        @brochure = Physical::General::Brochure.new(:category => @category)
      end

      def create
        @brochure = Physical::General::Brochure.new(brochure_params)
        @brochure.category = @category
        if @brochure.save
          flash[:success] = "#{@category} created."
          return redirect_to get_show_url_with_slug
        else
          flash[:alert] = "Something went wrong."
          render 'new'
        end
      end

      def show
      end

      def edit
      end

      def update
        @brochure.update_attributes(brochure_params)
        if @brochure.save
          flash[:success] = "#{@category} created."
          return redirect_to get_show_url_with_slug
        else
          flash[:alert] = "Something went wrong."
          render 'edit'
        end
      end

      private

        def set_category
          raise 'Not implemented. Set @category.'
        end

        def authorize_user
          forbidden unless can? :update, @brochure
        end

        def get_brochure
          if params.has_key? :slug
            brochures = Physical::General::Brochure.where(:category => @category, :slug => params[:slug]).order('position ASC').limit(1)
          else
            brochures = Physical::General::Brochure.where(:category => @category, :id => params[:id]).order('position ASC').limit(1)
          end
          @brochure = brochures.count == 0 ? nil : brochures.first
          return not_found unless @brochure
        end

        def brochure_params
          params.require(:brochure).permit(:title, :slug, :number_of_bed, :number_of_bath, :area, :has_loft, :short_description, :long_description, :ideal_for, :cover_image, :attachment, :is_published, :position)
        end

        def resolve_layout
          'columns-75-25'
        end

    end
  end
end