module Physical
  module Project
    class ProjectItemAsset < ActiveRecord::Base

      #
      # fields
      # project_item_id, album_item_id
      #

      #
      # callbacks
      #
      

      #
      # relations
      #

      belongs_to :project_item, :class_name => "Physical::Project::ProjectItem"
      belongs_to :album_item, :class_name => "Physical::Album::AlbumItem"
      accepts_nested_attributes_for :album_item

      #
      # validations
      #

      validates_associated :album_item

    end
  end
end