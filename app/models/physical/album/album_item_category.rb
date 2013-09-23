module Physical
  module Album
    class AlbumItemCategory < ActiveRecord::Base
      #
      # assocations
      #

      belongs_to :parent, :class_name => "Physical::Album::AlbumItemCategory"
      
      #
      # validations
      #

      validates :name, :uniqueness => true
      validates :position, :numericality => true
      validates :parent, :inclusion => { :in => Proc.new { Physical::Album::AlbumItemCategory.all }, :allow_nil => true }

      #
      # scope
      #

      default_scope order('position ASC, id ASC')

      UNCATEGORIZED = Physical::Album::AlbumItemCategory.find_by(:name => "Uncategorized")

    end
  end
end