module Frontend

  class StaticPagesController < ApplicationController
    #layout :resolve_layout

    #layout 'static_pages'

    def home
      #layout 'application'
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

      when 'home'
        'application'
      end
    end

  end

end