module Physical
  module Album
    class Album < ActiveRecord::Base
      acts_as_paranoid

      belongs_to :parent, :polymorphic => true
      validates :parent_id, :presence => true, :allow_blank => false
      validates :parent_type, :presence => true, :allow_blank => false
      validates :title, :presence => true, :allow_blank => false
      validate :parent, :check_parent_valid

      belongs_to :cover_image, :class_name => "Physical::Asset::ImageAsset"
      validate :cover_image, :check_cover_image
      has_many :items, :class_name => "::Physical::Album::AlbumItem", :source => :asset
      accepts_nested_attributes_for :items

      private

        def check_parent_valid

        end

        def check_cover_image
          valid_ids = Physical::Album::AlbumItem.where(:asset_type => "Physical::Asset::ImageAsset", :album_id => id ).map(&:id)
          unless cover_image_id != nil and valid_ids.include? cover_image_id.to_i 
            errors.add(:cover_image, "does not exist or is invalid.")
          end
        end

    end
  end
end