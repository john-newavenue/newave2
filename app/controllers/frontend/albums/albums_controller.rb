module Frontend
  module Albums
    class AlbumsController < ApplicationController

      layout 'albums'
      
      before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
      before_action :authorize_user, :only => [:new, :create, :edit, :update, :destroy]

      def index
      end

      def new
        @album = Physical::Album::Album.new
      end

      def create
        @album = Physical::Album::Album.new(album_params)
        respond_to do |format|
          if @album.save
            flash[:notice] = "Album created successfully."
            format.js
          else
            format.js { render :layout => false }
          end
        end
        
      end

      def show
        @album = Physical::Album::Album.find_by_id(params[:id])
        if @album
          case @album.parent_type
          when "Physical::Vendor::Vendor"
            @vendor = @album.parent.decorate
          end
        end

        # if @album == nil, show will render an "album not found" message
      end

      def edit
        @album = Physical::Album::Album.find_by_id(params[:id])
        respond_to do |format|
          format.js
        end
      end

      def upload
        @album = Physical::Album::Album.find_by_id(params[:id])
        # page variables dependent on the album owner
        case @album.parent_type
        when "Physical::Vendor::Vendor"
          @vendor = @album.parent.decorate
        else
        end
      end

      def update
        # @vendor = get_vendor
        # @vendor.update_attributes(vendor_params)
        # if @vendor.save
        #   flash[:notice] = "Your profile was updated successfully."
        #   redirect_to vendor_path(:slug => @vendor.slug)
        # else
        #   flash[:alert] = "Something went wrong. Please fix any errors."
        #   render 'edit'
        # end
        @album = Physical::Album::Album.find_by_id(params[:id])
        @album.update_attributes(album_params)
        respond_to do |format|
          if @album.save
            format.js
          else
          end
          
        end
      end

      def destroy
        # debugger
        @album.destroy
        flash[:notice] = "Album deleted successfully."
        debugger
        if @album.parent.class == Physical::Vendor::Vendor
          redirect_to vendor_profile_path(:slug => @album.parent.slug)
        else
          redirect_to user_profile_path(:username_slug => current_user.slug)
        end
      end

      private

        def authorize_user
          @album = params[:id] ? Physical::Album::Album.find_by_id(params[:id]) : Physical::Album::Album.new
          case params[:action]
          when 'create'
            forbidden unless can? :create, @album
          end
        end

        def album_params
          params.require(:album).permit(:title, :parent_id, :parent_type, :description, :cover_image_id, :items_attributes => [:id, :title, :description, :mark_delete, :position, :tag_list])
        end

    end
  end
end