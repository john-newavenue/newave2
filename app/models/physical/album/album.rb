module Physical
  module Album
    class Album < ActiveRecord::Base

      #
      # behaviors
      #
      acts_as_paranoid
      before_destroy :destroy_album_items
      acts_as_taggable
      acts_as_taggable_on :internal

      #
      # assocations
      #
      belongs_to :parent, :polymorphic => true
      belongs_to :cover_image, :class_name => "Physical::Asset::ImageAsset"
      has_many :items, :class_name => "::Physical::Album::AlbumItem", :source => :asset
      # has_many :images, :class_name => "::Physical::Album::AlbumItem", :source => :asset, :conditions => { :asset_type => "Physical::Asset::ImageAsset" }
      has_many :images, :class_name => "::Physical::Album::AlbumItem", :conditions => { :attachment_type => "image" }
      accepts_nested_attributes_for :items
      accepts_nested_attributes_for :images, allow_destroy: true

      #
      # validations
      #
      validates :parent_id, :presence => true, :allow_blank => false
      validates :parent_type, :presence => true, :allow_blank => false
      validates :title, :presence => true, :allow_blank => false
      validate :parent, :check_parent_valid
      validate :cover_image, :check_cover_image

      def after_upload_callback
        set_cover_image
      end

      def after_update_callback
        set_cover_image
      end

      private

        def destroy_album_items
          items.each { |i| i.destroy }
        end

        def check_parent_valid

        end

        def check_cover_image
          valid_ids = Physical::Album::AlbumItem.where(:asset_type => "Physical::Asset::ImageAsset", :album_id => id ).map(&:id)
          unless cover_image_id != nil and valid_ids.include? cover_image_id.to_i 
            cover_image = nil
          end
        end

        def set_cover_image
          imgs = images
          # cover_image points to image_assets, not album_items
          # since the deletion of album_items does NOT mean the
          # deletion of image_assets, nullify expired cover_image
          ci = self.cover_image
          if ci
            valid_image_assets = imgs.map { |i| i.asset }
            current_image_asset = cover_image
            if not (valid_image_assets.include? current_image_asset)
              ci = nil
            end
          end

          # for first time uploading pictures or no cover_image
          # selected when saving album, set cover image randomly
          if ci == nil and imgs.count > 0
            if not defined? valid_image_assets or valid_image_assets == nil
              valid_image_assets = imgs.map { |i| i.asset }
            end
            if valid_image_assets != nil and valid_image_assets.count > 0
              ci = valid_image_assets.sample
            end
          end
          self.cover_image = ci
          self.save
        end

    end
  end
end