module Frontend
  module Assets
    class UploadsController < ApplicationController

      before_filter :set_container
      protect_from_forgery :except => [:create]

      # # GET /uploads
      # # GET /uploads.json
      # def index
      #   @uploads = ::Physical::Asset::Asset.all
        
      #   respond_to do |format|
      #     format.html # index.html.erb
      #     format.json { render json: @uploads.map{|upload| upload.to_jq_upload } }
      #   end
      # end

      # # GET /uploads/1
      # # GET /uploads/1.json
      # def show
      #   @upload = ::Physical::Asset::Asset.find_by_id(params[:id])

      #   respond_to do |format|
      #     format.html # show.html.erb
      #     format.json { render json: @upload }
      #   end
      # end

      # GET /uploads/new
      # GET /uploads/new.json
      # def new
      #   @upload = Upload.new

      #   respond_to do |format|
      #     format.html # new.html.erb
      #     format.json { render json: @upload }
      #   end
      # end

      # # GET /uploads/1/edit
      # def edit
      #   @upload = Upload.find(params[:id])
      # end

      # POST /uploads
      # POST /uploads.json
      def create
        begin
          @upload = Logical::Asset::Upload.new(:file => upload_params[0], :container => @container)
          respond_to do |format|
            if @upload.save
              format.html {
                render :json => [@upload.to_jq_upload].to_json,
                :content_type => 'text/html',
                :layout => false
              }
              format.json { render json: {files: [@upload.to_jq_upload]}, status: :created, location: @upload.to_jq_upload["original"] }
            else
              format.html { render action: "new" }
              format.json { render json: @upload.errors, status: :unprocessable_entity }
            end
          end
        rescue => error
          debugger
          redirect_to root_path
        end
      end

      # # PUT /uploads/1
      # # PUT /uploads/1.json
      # def update
      #   @upload = Upload.find(params[:id])

      #   respond_to do |format|
      #     if @upload.update_attributes(params[:upload])
      #       format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
      #       format.json { head :no_content }
      #     else
      #       format.html { render action: "edit" }
      #       format.json { render json: @upload.errors, status: :unprocessable_entity }
      #     end
      #   end
      # end

      # # DELETE /uploads/1
      # # DELETE /uploads/1.json
      # def destroy
      #   debugger
      #   @upload = Physical::Asset::
      #   @upload.destroy

      #   respond_to do |format|
      #     format.html { redirect_to uploads_url }
      #     format.json { head :no_content }
      #   end
      # end

      private

        def authorize_user
          # TODO: ability with @container
        end

        def set_container
          cont_id = URI(request.referrer).path.split('/')[2].to_i # "http://somewhere.com/media/123/upload" returns 123
          @container = Physical::Album::Album.find_by_id(cont_id)
        end

        def upload_params
          # params.merge({:files => {}})
          params.require(:files)
        end

    end
  end
end