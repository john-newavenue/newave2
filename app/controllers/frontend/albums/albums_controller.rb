module Frontend
  module Albums
    class AlbumsController < ApplicationController

      layout :resolve_layout
      before_action :get_album
      before_action :authorize_user, :only => [:edit, :update, :upload_images]
      protect_from_forgery :except => [:upload_images]

      def show
      end

      def edit
      end

      def update
        @album.update_attributes(album_params)
        respond_to do |format|
          if @album.save
            # destroy objects marked for deletion
            params['album']['images_attributes'].keys.each do |n|
              if params['album']['images_attributes']["#{n}"]['mark_for_deletion'].in? ["on",true,1] 
                s = @album.items.where(:id => params['album']['images_attributes']["#{n}"]['id'])
                s[0].destroy if s.count == 1
              end
            end
            
            format.html {
              flash[:notice] = "Album Updated."
              redirect_to get_update_success_return_path
            }
          else
            format.html {
              flash[:alert] = "Something went wrong."
              render 'edit'
            }
          end
        end
      end

      def new_images
      end

      def upload_images
        @image = @album.images.build(:attachment => upload_images_params[0])
        respond_to do |format|
          if @image.save
            format.html {
              render :json => compile_return_params(@image).to_json,
                :content_type => 'text/html',
                :layout => false
            }
            format.json {
              render :json => {
                :files => [compile_return_params(@image)],
                :status => :created,
                :location => compile_return_params(@image)[:url]
              }
            }
          else
            format.json { render json: @image.errors, status: :unprocessable_entity }
          end
        end

      end

      private

        def compile_return_params(album_item)
          {
            'url' => album_item.attachment(:original),
            'name' =>  album_item.attachment_file_name,
            'thumbnail_url' => album_item.attachment(:small_square)
            # 'item_url'
            # 'item_id'
          }
        end

        def authorize_user
          forbidden unless can? :update, @album
        end

        def get_album
          raise 'Not implemented. Need to define @album.'
        end

        def get_update_success_return_url
          raise 'Not implemented.'
        end

        def album_params
          params.require(:album).permit(:title, :description, :cover_image_id, :images_attributes => [:id, :title, :description, :position, :tag_list])
        end

        def upload_images_params
          params.require(:files)
        end

        def resolve_layout
          'columns-75-25'
        end

    end
  end
end