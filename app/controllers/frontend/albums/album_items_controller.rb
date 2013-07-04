module Frontend
  module Albums
    class AlbumItemsController < ApplicationController
      before_filter :authenticate_user! => [:edit, :update, :destroy, :delete]
      before_action :authorize_user, :only => [:edit, :update, :destroy, :delete]
      before_action :get_item, :except => [:new, :create]

      layout 'one-column'

      def show
        respond_to do |format|
          format.js
          format.html
        end
      end

      def destroy
        @item.destroy
        respond_to do |format|
          format.js
        end
      end

      private

        def authorize_user
          # pending
        end

        def get_item
          @item = ::Physical::Album::AlbumItem.find_by_id(params[:id])
        end

        def item_params
          params.require(:item).permit('id')
        end


    end
  end
end