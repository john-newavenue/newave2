module Physical
  module Album
    class AlbumItem < ActiveRecord::Base
      #
      # callbacks
      #
      before_save :assign_ancestry
      before_save :assign_ancestral_asset


      #
      # assocations
      #
      belongs_to :album, :class_name => "Physical::Album::Album"
      belongs_to :asset, :polymorphic => true
      belongs_to :parent, :class_name => "Physical::Album::AlbumItem"
      belongs_to :root, :class_name => "Physical::Album::AlbumItem"

      #
      # scopes
      #
      default_scope order('position ASC')

      #
      # behaviors
      #
      acts_as_paranoid # soft delete
      acts_as_taggable

      #
      # public methods
      #

      def get_image_position_info
        # check if this is an image
        if asset.class.to_s == "Physical::Asset::ImageAsset"
          collection = album.images
          position = collection.index(self) + 1
          total = collection.length
          {
            :position => position,
            :total => total,
            :next_id => position + 1 > total ? nil : collection[position].id,
            :next_slug => position + 1 > total ? nil : collection[position].slug,
            :previous_id => position - 1 == 0 ? nil : collection[position-2].id,
            :previous_slug => position - 1 == 0 ? nil : collection[position-2].slug,
          }
        else
          false
        end
      end

      def slug
        # Make up a slug using the title for this for hinting in URL
        # else use the created date. This is just for aesthetics
        # but it's nice to see /item/183/nice-redwood-siding
        title.blank? ? created_at.strftime("%Y%m%d") : title.parameterize
      end

      private

        def assign_ancestry
          self.root = self.parent if self.parent
        end

        def assign_ancestral_asset
          self.asset = self.root.asset if self.root
        end



    end
  end
end