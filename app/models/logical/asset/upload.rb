module Logical
  module Asset
    class Upload < Logical::TablelessBase

      include Rails.application.routes.url_helpers

      attr_accessor :file, :container, :asset

      validates :file, :presence => true
      validates :container, :presence => true
      validate :file, :valid_file_for_container

      def save
        if self.valid? and @asset.valid?
          # save the asset
          @asset.save
          # save it to the uploader's album
          @album_item = container.items.create(:asset => @asset)
          # this is a newly uploaded asset, so save a reference to the originating album too
          @asset_base = @asset.asset
          @asset_base.origin_album_item = @album_item
          @asset_base.save
        else
          false
        end
      end

      def to_jq_upload
        output = @asset.to_jq_upload
        output['delete_url'] = item_path(@album_item)
        output['item_id'] = @album_item.id
        output
      end

      def valid_file_for_container
        case container.parent_type
        when 'Physical::Vendor::Vendor'
          # accept images
          if /image\/(png|jpeg|jpg|gif)/i.match file.content_type 
            @asset = Physical::Asset::ImageAsset.new(:image => file)
            @type = "photo"
          else
            errors.add(:file, "Only PNG, JPEG, JPG, and GIF files allowed in albums.")
          end
        else
          # other cases
        end
      end

    end
  end
end