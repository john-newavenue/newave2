module Physical
  module Project
    class ProjectItemAsset < ActiveRecord::Base

      #
      # relations
      #

      belongs_to :project_item, :class_name => "Physical::Project::ProjectItem"
      belongs_to :album_item, :class_name => "Physical::Album::AlbumItem"

      #
      # validations
      #

      validates_associated :album_item

    end
  end
end