module Physical
  module Project
    class ProjectItem < ActiveRecord::Base

      #
      # fields:
      # "id", "project_id", "body", "deleted_at", "created_at", "updated_at", "private",, "user_id", "category",, "has_assets",

      # categories (lower case)
      #   * text
      #   * clipped_picture
      #   * uploaded_picture
      #   * milestone
      #   * joined

      #
      # callbacks
      #
      # before_save ProjectItemWrapper.new
      before_save :remove_associated_album_items

      #
      # relations
      #

      belongs_to :project, :class_name => "Physical::Project::Project"
      belongs_to :user, :class_name => "::User"
      has_many :project_item_assets, :class_name => "Physical::Project::ProjectItemAsset"
      
      # has_many :album_items, :through => :project_item_assets, :class_name => "Physical::Album::AlbumItem"
      # has_many :albums, :through => :album_items
      # has_many :album_projects, :through => :albums, :source_type => "Physical::Project::Project", :source => :parent, :as => :album_projects
      
      accepts_nested_attributes_for :project_item_assets

      #
      # validations
      #

      validates_associated :project, :project_item_assets

      #
      # behaviors
      #

      # acts_as_paranoid
      

      #
      # scope
      #

      # scope :public, -> { where('project_items.private is false')}
      scope :community_feed, -> { joins('LEFT JOIN projects ON projects.id = project_items.project_id').where("(category LIKE ?) OR (project_id IS NOT NULL and projects.private IS FALSE)", "joined").order('created_at DESC') }
      scope :private, -> { where('project_items.private is true')}
      scope :none, -> { where('false') }
      default_scope -> { where('"project_items"."deleted_at" IS NULL')}

      def remove_associated_album_items
        if deleted_at
          # find related album items (clipped, saved pictures) and destroy them
          Physical::Album::AlbumItem.joins(
            'INNER JOIN "project_item_assets" ON "project_item_assets"."album_item_id" = "album_items"."id" ' +
            'INNER JOIN "project_items" ON "project_items"."id" = "project_item_assets"."project_item_id"'
          ).where(
            '"project_items"."id" = ? AND "album_items"."deleted_at" IS NULL', id
          ).readonly(false).update_all(:deleted_at => Time.now())
        end
      end

      def save(params = {:validate => true})
          
        if new_record?

          self.category = "text" if not self.category # unless otherwise overridden

          number_of_assets = project_item_assets.length

          project_item_assets.each do |project_item_asset|
            # a new album item is built for clipped and uploaded files
            if project_item_asset.album_item
              # assign album item's album to be the project's primary
              project_item_asset.album_item.album = project.primary_album

              if number_of_assets == 1
                self.has_assets = true
                # if the album item came from a different album, it was clipped
                # check what kind of asset is involved and assign the category
                image_regex = /^image\/(png|gif|jpeg|jpg|bmp)/
                attachment_content_type = project_item_asset.album_item.attachment_content_type
                # if project_item_asset.album_item.parent and (project_item_asset.album_item.parent.album != project.primary_album and project_item_asset.album_item.root_id)
                if project_item_asset.album_item.parent_id
                  if image_regex.match attachment_content_type or project_item_asset.album_item.legacy_display_image_url
                    self.category = "clipped_picture"
                  end
                else
                  if image_regex.match attachment_content_type
                    self.category = "uploaded_picture"
                  end
                end
              end
              # TODO, FUTURE: number_of_assets > 1, multiple assets associated with one project item
            end
          end
        end
        
        super(params)
        
        project.touch if project

      end

    end

  end
end