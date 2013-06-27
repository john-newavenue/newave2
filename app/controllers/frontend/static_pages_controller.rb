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

    private

      def resolve_layout
        case action_name
        when 'home'
          'application'
        else 
          'about'
        end
      end

  end

end