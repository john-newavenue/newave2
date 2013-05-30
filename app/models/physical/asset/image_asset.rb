require 'azzet'

module Physical
  module Asset
    class ImageAsset < ActiveRecord::Base

      acts_as_azzet

      has_attached_file :image, :styles => { 
          :small_square => "166x166#",
          :medium_square => "334x334#",
          :large_square => "500x500#",
          :small => "166x166",
          :medium => "334x334",
          :large => "500x500"
        }

      validates_with AttachmentContentTypeValidator, :attributes => :image, :content_type => /^image\/(png|gif|jpeg|jpg)/
      validates_with AttachmentPresenceValidator, :attributes => :image
      validates_with AttachmentSizeValidator, :attributes => :image, :in => (1.kilobytes..(2.5).megabytes)

    end
  end
end