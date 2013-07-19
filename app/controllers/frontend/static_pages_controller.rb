module Frontend

  class StaticPagesController < ApplicationController
    layout :resolve_layout

    def home
    end

    def about
    end

    def terms
    end

    def privacy
    end

    def team
    end

    def faqs
    end

    def investors
    end

    def how
    end

    def jobs
    end

    def press
    end

    def join
    end

    def brochure_floorplans
        @collection = Physical::General::Brochure.floorplans
    end

    def brochure_floorplan
        @brochure = Physical::General::Brochure.find_by(:slug => params[:slug])
    end

    def brochure_clients
        @collection = Physical::General::Brochure.clients
    end

    def brochure_client
        @brochure = Physical::General::Brochure.find_by(:slug => params[:slug])
    end

    private

      def resolve_layout
        case action_name
        when 'home', 'join'
          'application'
        when 'brochure_floorplans', 'brochure_clients','brochure_floorplan', 'brochure_client'
          'one-column'
        else 
          'about'
        end
      end

  end

end