module Physical
  module Album
    class AlbumItem < ActiveRecord::Base
      belongs_to :album, :class_name => "Physical::Album::Album"
      belongs_to :asset, :class_name => "Physical::Asset::Asset"
    end
  end
end