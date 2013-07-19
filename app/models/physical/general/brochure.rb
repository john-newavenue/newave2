module Physical
  module General
    class Brochure < ActiveRecord::Base

      # title, position, short_description, long_description, area, number_of_bath, number_of_bed, has_loft, category, album

      #
      # categories
      #

      CLIENT_CATEGORY = 0
      FLOORPLAN_CATEGORY = 1
      
      CATEGORIES_DISPLAY = [ ["Client", CLIENT_CATEGORY], ["Floor Plan", FLOORPLAN_CATEGORY] ] # for forms, links
      CATEGORIES = CATEGORIES_DISPLAY.map {|f| f[1] } # just the values

      #
      # behaviors
      #

      
      #
      # assocations
      #

      belongs_to :album, :class_name => "Physical::Album::Album"
      has_attached_file :cover_image, :styles => { 
          :small_square => "80x80#",
          :medium_square => "334x334#",
        }

      #
      # validations
      #

      validates :category, :presence => true, :allow_blank => false, :inclusion => { :in => CATEGORIES }
      validates :album, :presence => true, :allow_blank => false
      validates :slug, :presence => true, :allow_blank => false, :format => { :with => /\A[A-Za-z0-9-_]+\z/i, :message => "Invalid format."}
      validates :title, :presence => true, :allow_blank => false

      validates :area, :numericality => { :minimum => 0 }
      validates :number_of_bed, :numericality => { :minimum => 0 }
      validates :number_of_bath, :numericality => { :minimum => 0 }

      validates_with AttachmentContentTypeValidator, :attributes => :cover_image, :content_type => /^image\/(png|gif|jpeg|jpg)/
      validates_with AttachmentPresenceValidator, :attributes => :cover_image
      validates_with AttachmentSizeValidator, :attributes => :cover_image, :in => (1.kilobytes..(2.5).megabytes)

      #
      # scopes
      #

      scope :clients, -> { where(:category => 0).order('position ASC') }
      scope :floorplans, -> { where(:category => 1).order('position ASC') }

    end
  end
end