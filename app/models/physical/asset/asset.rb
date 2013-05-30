module Physical
  module Asset
    class Asset < ActiveRecord::Base
      
      belongs_to :azzet, :polymorphic => true

      belongs_to :origin_album_item, :class_name => "Physical::Album::AlbumItem"

      validates :azzet, :presence => true, :allow_blank => false
      validates :soft_delete, :default => false

    end
  end
end