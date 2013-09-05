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

    def featured_architects
        @featured_architect_profiles = Physical::User::UserProfile.includes(:user).where('is_featured_architect IS TRUE').order('featured_architect_position ASC, id DESC')
    end

    def featured_architect
        profiles = Physical::User::UserProfile.includes(:user).where("is_featured_architect IS TRUE AND users.slug='#{params[:slug]}'").references(:user).limit(1)
        return not_found if profiles.count == 0
        @profile = profiles.first
    end

    private

      def resolve_layout
        case action_name
        when 'home', 'join'
          'application'
        when 'brochure_floorplans', 'brochure_clients','brochure_floorplan', 'brochure_client', 'featured_architects'
          'columns-75-25'
        when 'featured_architect'
          'columns-25-75'
        else 
          'about'
        end
      end

  end

end