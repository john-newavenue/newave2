module Frontend
  module Crm
    class AlbumsController < CrmBaseController

      def index
        if params.has_key? :tags
          tags = params[:tags].split(',')
          @albums = Physical::Album::Album.tagged_with(tags, :any => true)
        else
          @albums = Physical::Album::Album.all
        end
      end

      def show
      end

      def edit
      end

      def update
      end

      def delete
      end

      def create
      end

      def new
      end

    end
  end
end