module Frontend
  module Albums
    class AlbumItemsController < ApplicationController
      before_filter :authenticate_user! => [:edit, :update, :destroy, :delete]
      before_action :authorize_user, :only => [:edit, :update, :destroy, :delete]
      before_action :get_item, :except => [:new, :create, :index_ideas]
      before_action :get_category_id_from_param, :only => [:index_ideas]

      layout :resolve_layout

      def index_ideas
        
        category_id = get_category_id_from_param

        q = "albums.parent_type = 'Physical::Project::Project' AND projects.private IS FALSE AND album_items.kind = 'picture'"
        q = "#{q} AND album_items.category_id = #{category_id}" if category_id

        @album_items = Physical::Album::AlbumItem.joins(:project, :album)
          .where(q)
          .order('id DESC')
          .page(get_page_param)

      end

      def new
        @parent = Physical::Album::AlbumItem.find_by(:id => params[:album_item_id].to_i )
        @album_item = Physical::Album::AlbumItem.new(
          :parent => @parent,
          :root => @parent.root ? @parent.root : @parent
        )

        @modal = 'frontend/albums/album_items/save_image_modal'
        if current_user.has_role?(:customer)
          @modal = 'frontend/projects/projects/prompt_create_first_project' if current_user.projects.count < 1
        elsif current_user.has_role?(:vendor)
          @modal = 'frontend/projects/projects/prompt_no_assigned_project' if current_user.projects.count < 1
        end

        respond_to do |format|
          format.js { render :partial => 'frontend/prompt_modal.js.coffee', :layout => false, :locals => { :modal => @modal } }
        end

      end

      def show
        respond_to do |format|
          format.js { render :layout => false }
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

        def get_category_id_from_param
          if params.has_key?(:category)
            s = params[:category]
            Physical::Album::AlbumItemCategory.all.each do |c|
              return c.id if c.name.parameterize == s
            end
          end
          return nil
        end

        def item_params
          params.require(:item).permit('id')
        end

        def resolve_layout
          case action_name
          when 'index_ideas'
            'columns-25-75'
          else
            'one-column'
          end
        end


    end
  end
end