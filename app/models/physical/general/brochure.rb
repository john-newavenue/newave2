module Physical
  module General
    class Brochure < ActiveRecord::Base

      # title, position, short_description, long_description, area, number_of_bath, number_of_bed, has_loft, category, album, is_published

      
      CLIENT_CATEGORY = "Client"
      FLOORPLAN_CATEGORY = "Floor Plan"
      CATEGORIES = [CLIENT_CATEGORY, FLOORPLAN_CATEGORY]

      #
      # callbacks
      #

      before_create :build_associations
      
      #
      # assocations
      #

      belongs_to :album, :class_name => "Physical::Album::Album"

      has_attached_file :cover_image, :styles => { 
          :small_square => "80x80#",
          :medium_square => "334x334#",
          :large_square => "500x500#",
        },
        :default_url => 'https://b6694dc98fc00ffe8b6d-3d8cead74be35266d0f147cdde9ccbfd.ssl.cf1.rackcdn.com/general/blank_user.png',
        :path => 'brochures/:id/cover_image/:style/:filename'

      has_attached_file :attachment,
        :path => 'brochures/:id/attachment/:filename'

      #
      # validations
      #

      validates :category, :presence => true, :allow_blank => false, :inclusion => { :in => CATEGORIES }
      
      validates :slug, :presence => true, :allow_blank => false, :format => { :with => /\A[A-Za-z0-9\-_]+\z/i, :message => "Invalid format."}, :uniqueness => true
      validates :title, :presence => true, :allow_blank => false
      validates :position, :numericality => true

      validates :area, :numericality => { :greater_than_or_equal_to => 0 }
      validates :number_of_bed, :numericality => { :greater_than_or_equal_to => 0 }, :format => { :with => /\A\d(\.\d)?\z/ }
      validates :number_of_bath, :numericality => { :greater_than_or_equal_to => 0 }, :format => { :with => /\A\d(\.\d)?\z/ }

      validates_with AttachmentContentTypeValidator, :attributes => :cover_image, :content_type => /^image\/(png|gif|jpeg|jpg)/
      validates_with AttachmentSizeValidator, :attributes => :cover_image, :in => (1.kilobytes..(2.5).megabytes)
      validates_with AttachmentContentTypeValidator, :attributes => :cover_image, :content_type => /^application\/pdf/
      validates_with AttachmentSizeValidator, :attributes => :attachment, :in => (1.kilobytes..(10).megabytes)

      #
      # scopes
      #

      scope :clients, -> { where(:category => 0).order('position ASC') }
      scope :floorplans, -> { where(:category => 1).order('position ASC') }

      private

        def build_associations
          self.build_album(:parent => self, :title => "Featured Images")
        end

    end
  end
end