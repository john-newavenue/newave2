module Physical
  module Album
    class Album < ActiveRecord::Base

      #
      # behaviors
      #
      acts_as_paranoid
      before_destroy :destroy_album_items

      #
      # assocations
      #
      belongs_to :parent, :polymorphic => true
      belongs_to :cover_image, :class_name => "Physical::Asset::ImageAsset"
      has_many :items, :class_name => "::Physical::Album::AlbumItem", :source => :asset
      has_many :images, :class_name => "::Physical::Album::AlbumItem", :source => :asset, :conditions => { :asset_type => "Physical::Asset::ImageAsset" }
      accepts_nested_attributes_for :items

      #
      # validations
      #
      validates :parent_id, :presence => true, :allow_blank => false
      validates :parent_type, :presence => true, :allow_blank => false
      validates :title, :presence => true, :allow_blank => false
      validate :parent, :check_parent_valid
      validate :cover_image, :check_cover_image

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

    end
  end
end