module Physical
  module User
    class UserProfile < ActiveRecord::Base
      

      #
      # fields and associations
      #

      has_attached_file :avatar, :styles => { :tiny => "24x24#", :small => "64x64#", :profile => "188x250#" }
      belongs_to :user
      belongs_to :address, :class_name => "Physical::General::Address"

      #
      # validations
      #

      validates_with AttachmentContentTypeValidator, :attributes => :avatar, :content_type => /^image\/(png|gif|jpeg|jpg)/
      validates_with AttachmentSizeValidator, :attributes => :avatar, :in => (1.kilobytes..(500).kilobytes)

    end
  end
end