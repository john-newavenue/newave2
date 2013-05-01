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

    private

      def resolve_layout
        case action_name
        when 'about','terms','privacy'
          'about'
        else 
          'application'
        end
      end

  end

end