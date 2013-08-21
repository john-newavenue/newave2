module Physical
  module Project
    class ProjectItem < ActiveRecord::Base

      #
      # fields:
      # id, body, deleted_at, created_at, updated_at, category, has_assets, project

      # categories (lower case)
      #   * text
      #   * clipped_picture
      #   * uploaded_picture
      #   * milestone

      #
      # callbacks
      #
      # before_save ProjectItemWrapper.new

      #
      # relations
      #

      belongs_to :project, :class_name => "Physical::Project::Project"
      belongs_to :user, :class_name => "::User"
      has_many :project_item_assets, :class_name => "Physical::Project::ProjectItemAsset"
      accepts_nested_attributes_for :project_item_assets

      #
      # validations
      #

      validates_associated :project, :project_item_assets

      #
      # behaviors
      #

      acts_as_paranoid
      

      #
      # scope
      #

      scope :public, -> { where('project_items.private is false')}
      scope :private, -> { where('project_items.private is true')}
      scope :none, -> { where('false') }

      def save
          
        if new_record?

          self.category = "text" # unless otherwise overridden

          number_of_assets = project_item_assets.length

          project_item_assets.each do |project_item_asset|
            # a new album item is built for clipped and uploaded files
            if project_item_asset.album_item
              # assign album item's album to be the project's primary
              project_item_asset.album_item.album = project.primary_album

              if number_of_assets == 1
                self.has_assets = true
                # if the album item came from a different project, it was clipped
                # check what kind of asset is involved and assign the category
                if project_item_asset.album_item.parent and project_item_asset.album_item.parent.album != project.primary_album
                  if project_item_assets.first.album_item.parent.asset_type == "Physical::Asset::ImageAsset"
                    self.category = "clipped_picture"
                  end
                else
                  if project_item_assets.first.album_item.parent.asset_type == "Physical::Asset::ImageAsset"
                    self.category = "uploaded_picture"
                  end
                end
              end
              # TODO, FUTURE: number_of_assets > 1, multiple assets associated with one project item
            end
          end
        end
        
        super
        
        project.touch

      end

    end

    # class ProjectItemWrapper
    #   def after_save(record)
    #     # create album item if needed

    #     # create project item asset

    #     #


    #     # update category and has_assets
    #     current_category = record.category
    #     current_has_assets = record.has_assets
    #     project_item_assets = record.project_item_assets
    #     if project_item_assets.count > 0
    #       record.has_assets = true
    #       if project_item_assets.count == 1
    #         album_item = record.project_item_assets.first.album_item
    #         if album_item.album.parent == record.project
    #           record.category = "uploaded_picture"
    #         else
    #           record.cateogry = "clipped_picture"
    #         end
    #         # 
    #       end
    #     else
    #       record.category = "text"
    #       record.has_assets = false
    #     end
    #     record.save if record.category != current_category and record.has_assets != record.has_assets
    #   end
    # end

  end
end