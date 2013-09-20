module Physical
  module Album
    class AlbumItem < ActiveRecord::Base

      # :kind => picture, product, etc.

      #
      # callbacks
      #

      before_save :assign_ancestry
      before_save :assign_ancestral_attachment
      before_save :assign_attachment_type
      after_create :add_to_project_timeline

      #
      # assocations
      #

      belongs_to :album, :class_name => "Physical::Album::Album"
      belongs_to :asset, :polymorphic => true
      belongs_to :parent, :class_name => "Physical::Album::AlbumItem"
      belongs_to :root, :class_name => "Physical::Album::AlbumItem"
      belongs_to :user, :class_name => "::User"
      belongs_to :category, :class_name => "Physical::Album::AlbumItemCategory"

      has_one :project, :through => :album, :class_name => "Physical::Project::Project", :source => :parent, :source_type => "Physical::Project::Project"

      #
      # Paperclip
      #

      # resolves migration mismatch of asset ids
      Paperclip.interpolates :id_or_legacy_id do |attachment, style|
        if attachment.instance.root_id
          attachment.instance.legacy_asset_id ? attachment.instance.legacy_asset_id : attachment.instance.root_id
        else
          attachment.instance.legacy_asset_id ? attachment.instance.legacy_asset_id : attachment.instance.id
        end
      end

      has_attached_file :attachment, 
        :styles => { 
          :small_square => "80x80#",
          :large_square => "500x500#",
          :medium_rectangle => "800x600#", # size of legacy_display_image 
          :large => "1440x960"
        }, 
        :path => 'assets/:id_or_legacy_id/:style/:filename',
        :preserve_files => Rails.env != "production"

      before_post_process :skip_for_nonimage


      #
      # validations
      #


      # validates_with AttachmentContentTypeValidator, :attributes => :attachment, :content_type => /^image\/(png|gif|jpeg|jpg|bmp)/
      # validates_with AttachmentPresenceValidator, :attributes => :attachment
      # validates_with AttachmentSizeValidator, :attributes => :attachment, :in => (1.kilobytes..(2.5).megabytes)
      validates_with AttachmentSizeValidator, :attributes => :attachment, :in => (1.kilobytes..(5).megabytes)

      validates :category, :inclusion => { :in => Proc.new { Physical::Album::AlbumItemCategory.all }, :allow_nil => true }

      #
      # scopes
      #

      default_scope order('position ASC, id DESC')

      #
      # behaviors
      #
      # acts_as_paranoid # soft delete
      acts_as_taggable

      #
      # public methods
      #

      def get_attachment2(size)
        if legacy_display_image2_url
          return { 
            :small_square => legacy_thumbnail_span3_url,
            :medium_square => legacy_display_image_url,
            :large_square => legacy_display_image_url,
            :small_rectangle => legacy_thumbnail_span3_url,  # size of legacy_thumbnail_span3 
            :medium_rectangle => legacy_display_image_url, # size of legacy_display_image 
            :tall_large_rectangle => legacy_display_image2_url, # size of legacy_display_image2 
            :large => legacy_display_image2_url
          }[size]
        else
          return attachment(size)
        end
      end

      def get_image_position_info
        # check if this is an image
        if kind == "picture"
          collection = album.images
          position = collection.index(self) + 1
          total = collection.length
          {
            :position => position,
            :total => total,
            :next_id => position + 1 > total ? nil : collection[position].id,
            :next_slug => position + 1 > total ? nil : collection[position].slug,
            :previous_id => position - 1 == 0 ? nil : collection[position-2].id,
            :previous_slug => position - 1 == 0 ? nil : collection[position-2].slug
          }
        else
          nil
        end
      end

      def get_neighboring_images(max_neighbors = 4)
        if kind == "picture"
          collection = album.images
          position = collection.index(self)
          total = collection.length
          # neighbors = [collection][(position-max_neighbors)..(position+max_neighbors)]
          
          # do_pop = true
          # if neighbors.count > max_neighbors + 1
          #   while 
          # end

          if max_neighbors + 1 >= total
            neighbors = collection
          else
            look = 1
            where = 1
            neighbors = [ collection[position] ]
            while max_neighbors > neighbors.count
              if where == 1
                neighbors.push(collection[position + look])
              else
                neighbors.unshift(collection[position - look]) if position - look > -1 # negatives index arrays backwards, negate them
              end
              neighbors.compact!
              look = look + 1 if where == -1
              where = -1*where
            end
          end

          # puts "Collection retrieved: #{collection.map(&:id)}"
          # puts "Neighbors retrieved: #{neighbors.map(&:id)}"

          neighbors = [] if neighbors == nil
          neighbors
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
          if self.parent
            if self.parent.root
              self.root = self.parent.root
            else
              self.root = self.parent
            end
          end
        end

        def assign_ancestral_attachment
          # copy over root's attachment info
          if self.root
            self.attachment_file_name = self.root.attachment_file_name
            self.attachment_content_type = self.root.attachment_content_type
            self.attachment_file_size = self.root.attachment_file_size
            self.attachment_updated_at = self.root.attachment_updated_at
            self.legacy_original_image_url = self.root.legacy_original_image_url if self.root.legacy_original_image_url
            self.legacy_thumbnail_span3_url = self.root.legacy_thumbnail_span3_url if self.root.legacy_thumbnail_span3_url
            self.legacy_display_image_url = self.root.legacy_display_image_url if self.root.legacy_display_image_url
            self.legacy_display_image2_url = self.root.legacy_display_image2_url if self.root.legacy_display_image2_url
          end
        end

        def assign_attachment_type
          case attachment_content_type
          when /^image\/(png|gif|jpeg|jpg|bmp)/
            self.attachment_type = "image"
          when /^text\//
            self.attachment_type = "text"
          when /^application\/pdf/
            self.attachment_type = "pdf"
          end
        end

        def skip_for_nonimage
          # don't let paperclip create thumbnails for non images
          nil != (/^image\/(png|gif|jpeg|jpg|bmp)/.match attachment_content_type)
        end

        def add_to_project_timeline
          if album.parent_type == "Physical::Project::Project"
            project = album.parent
            project_item = project.items.build(:user => user)
            project_item.project_item_assets.build(
              :album_item => self
            )
            project_item.save
          end
        end


    end
  end
end