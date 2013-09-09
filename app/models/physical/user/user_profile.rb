module Physical
  module User
    class UserProfile < ActiveRecord::Base
      

      #
      # fields and associations
      #

      has_attached_file :avatar, 
        :styles => { :tiny => "24x24#", :small => "64x64#", :square => "300x300#" }, 
        :default_url => 'https://b6694dc98fc00ffe8b6d-3d8cead74be35266d0f147cdde9ccbfd.ssl.cf1.rackcdn.com/general/blank_user.png',
        :path => 'profiles/:id/:style/:filename'

      #
      # assocations
      # 

      belongs_to :user, :class_name => "::User"
      belongs_to :address, :class_name => "Physical::General::Address"
      belongs_to :featured_work_album, :class_name => "Physical::Album::Album"

      #
      # validations
      #

      validates :featured_architect_position, :numericality => true

      validates_with AttachmentContentTypeValidator, :attributes => :avatar, :content_type => /^image\/(png|gif|jpeg|jpg)/
      validates_with AttachmentSizeValidator, :attributes => :avatar, :in => (1.kilobytes..(1000).kilobytes)

    end
  end
end