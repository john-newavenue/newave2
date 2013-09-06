module Physical
  module Album
    class AlbumItem < ActiveRecord::Base


      #
      # callbacks
      #

      before_save :assign_ancestry
      before_save :assign_ancestral_attachment
      before_save :assign_attachment_type

      #
      # assocations
      #
      belongs_to :album, :class_name => "Physical::Album::Album"
      belongs_to :asset, :polymorphic => true
      belongs_to :parent, :class_name => "Physical::Album::AlbumItem"
      belongs_to :root, :class_name => "Physical::Album::AlbumItem"


      #
      # Paperclip
      #

      # resolves migration mismatch of asset ids
      Paperclip.interpolates :id_or_legacy_id do |attachment, style|
        attachment.instance.legacy_asset_id ? attachment.instance.legacy_asset_id : attachment.instance.id
      end

      has_attached_file :attachment, 
        :styles => { 
          # :small_square => "166x166#",
          :small_square => "80x80#",
          :medium_square => "334x334#",
          :large_square => "500x500#",
          # :small => "166x166",
          # :medium => "334x334",
          :large => "1440x960"
        }, 
        :path => 'assets/:id_or_legacy_id/:style/:filename',
        :preserve_files => true

      before_post_process :skip_for_nonimage

      # validates_with AttachmentContentTypeValidator, :attributes => :attachment, :content_type => /^image\/(png|gif|jpeg|jpg|bmp)/
      # validates_with AttachmentPresenceValidator, :attributes => :attachment
      # validates_with AttachmentSizeValidator, :attributes => :attachment, :in => (1.kilobytes..(2.5).megabytes)
      validates_with AttachmentSizeValidator, :attributes => :attachment, :in => (1.kilobytes..(5).megabytes)

      #
      # scopes
      #

      default_scope order('position ASC, id DESC')

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
        if attachment_type == "image"
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
        if attachment_type == "image"
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
              puts "Look #{look} - #{position} - #{total}"
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

          puts "Collection retrieved: #{collection.map(&:id)}"
          puts "Neighbors retrieved: #{neighbors.map(&:id)}"

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


    end
  end
end